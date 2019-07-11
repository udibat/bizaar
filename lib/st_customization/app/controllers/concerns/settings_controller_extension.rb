require 'active_support/concern'

module SettingsControllerExtension
  extend ActiveSupport::Concern
  include TutorChecker
  include MemberChecker

  def qualifications
    @selected_left_navi_link = "qualifications"
    @pending_certifications = CertificationWizardDecorator.decorate_collection(
      @current_user.custom_profile.certifications.status_pending).to_a
    @approved_certifications = CertificationWizardDecorator.decorate_collection(
      @current_user.custom_profile.certifications.status_approved).to_a      
    @rejected_certifications = CertificationWizardDecorator.decorate_collection(
      @current_user.custom_profile.certifications.status_rejected).to_a

    @certification_was_created = flash[:certification_was_created].present?

    @new_certification = @current_user.custom_profile.certifications.build
  end

  def id_verification
    @selected_left_navi_link = "id_verification"
    @id_verification = @current_user.custom_profile.id_verifications.first
    @id_verification ||= @current_user.custom_profile.id_verifications.build
  end

  def member_payments
    @selected_left_navi_link = "payments"
    @existing_cards = CustomStripeUtils.list_customer_payment_cards(@current_user, @current_community)
  end

  def social_media
    @selected_left_navi_link = "social_media"
    @custom_profile = @current_user.custom_profile
  end

  def cover_photos
    @selected_left_navi_link = "cover_photos"
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

