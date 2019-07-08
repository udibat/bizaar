require 'active_support/concern'

module PersonExtension
  extend ActiveSupport::Concern

  MIN_PERSON_AGE = 19

  included do

    has_one :tutor_signup_status, dependent: :destroy
    has_one :member_signup_status, dependent: :destroy
    has_one :custom_profile, dependent: :destroy
    accepts_nested_attributes_for :custom_profile
    validates_associated :custom_profile


    after_create :create_custom_profile

    validate :validate_age
    validates_presence_of :birthday, unless: :is_admin?
    validates_presence_of :zip_code, unless: :is_admin?

    def validate_age
      if birthday.present? && birthday > MIN_PERSON_AGE.years.ago.to_date
        errors.add(:birthday, "You should be over #{MIN_PERSON_AGE} years old.")
      end
    end

    # we'll use our own less strict consent logic
    def skip_st_consent!
      community_membership.consent = 'SHARETRIBE1.0'
      community_membership.status = 'accepted'
      community_membership.save!
    end

    def mark_as_tutor!
      self.is_tutor = true
      self.save!
      unless self.tutor_signup_status
        self.create_tutor_signup_status
      end
    end

    def mark_as_member!
      self.is_tutor = false
      self.save!
      unless self.member_signup_status
        self.create_member_signup_status
      end
    end

  end

  def signup_process_complete?
    signup_status.signup_status_finished?
  end

  def signup_status
    if is_tutor?
      tutor_signup_status
    else
      member_signup_status
    end
  end

  # class_methods do

  # end

end

