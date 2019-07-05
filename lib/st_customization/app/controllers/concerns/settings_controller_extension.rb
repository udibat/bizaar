require 'active_support/concern'

module SettingsControllerExtension
  extend ActiveSupport::Concern
  include TutorChecker
  include MemberChecker

  def qualifications
    @existing_certifications = @current_user.custom_profile.certifications
  end

  def id_verification
    @existing_id_verifications = @current_user.custom_profile.id_verifications
  end

  def member_payments
    @selected_left_navi_link = "Payments"
  end

  included do

    before_action :ensure_user_is_tutor, only: [:qualifications]
    before_action :ensure_user_is_member, only: [:member_payments]
    before_action :manage_view_path

  end

  # class_methods do

  # end

private

  def manage_view_path
    unless @current_user.is_tutor?
      prepend_view_path Rails.root.to_s + "/lib/st_customization/app/views/member_settings"
    end
  end
  

end

