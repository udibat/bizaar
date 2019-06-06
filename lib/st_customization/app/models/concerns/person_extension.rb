require 'active_support/concern'

module PersonExtension
  extend ActiveSupport::Concern

  included do

    has_one :tutor_signup_status, dependent: :destroy
    has_one :custom_profile, dependent: :destroy

  end

  # class_methods do

  # end

end

