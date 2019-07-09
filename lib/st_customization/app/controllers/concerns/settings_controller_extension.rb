require 'active_support/concern'

module SettingsControllerExtension
  extend ActiveSupport::Concern
  include TutorChecker
  include MemberChecker

  def qualifications
    @existing_certifications = @current_user.custom_profile.certifications.to_a
    @new_certification = @current_user.custom_profile.certifications.build
  end

  def id_verification
    @id_verification = @current_user.custom_profile.id_verifications.first
    @id_verification ||= @current_user.custom_profile.id_verifications.build
  end

  def member_payments
    @selected_left_navi_link = "Payments"
    @existing_cards = CustomStripeUtils.list_customer_payment_cards(@current_user, @current_community)
  end

  def social_media
    @custom_profile = @current_user.custom_profile
  end

  def cover_photos
    @custom_profile = @current_user.custom_profile
  end

  included do

    before_action :ensure_user_is_tutor, only: [:qualifications, :cover_photos]
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

