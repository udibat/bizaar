require 'active_support/concern'

module PersonExtension
  extend ActiveSupport::Concern

  MIN_PERSON_AGE = 19

  included do

    has_one :tutor_signup_status, dependent: :destroy
    has_one :custom_profile, dependent: :destroy
    after_create :create_custom_profile

    validate :validate_age

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

  end

  # class_methods do

  # end

end

