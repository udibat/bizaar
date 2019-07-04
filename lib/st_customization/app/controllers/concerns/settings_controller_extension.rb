require 'active_support/concern'

module SettingsControllerExtension
  extend ActiveSupport::Concern
  include TutorChecker

  def qualifications
    @existing_certifications = @current_user.custom_profile.certifications
  end

  def id_verification
    @existing_id_verifications = @current_user.custom_profile.id_verifications
  end


  included do

    before_action :ensure_user_is_tutor, only: [:qualifications, :id_verification]

  end

  # class_methods do

  # end

# private
  

end

