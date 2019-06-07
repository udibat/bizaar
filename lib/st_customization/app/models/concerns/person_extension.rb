require 'active_support/concern'

module PersonExtension
  extend ActiveSupport::Concern

  included do

    has_one :tutor_signup_status, dependent: :destroy
    has_one :custom_profile, dependent: :destroy

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
        tutor_signup_status = self.create_tutor_signup_status
      end
      
    end

  end

  # class_methods do

  # end

end

