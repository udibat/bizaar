class TutorWizardController < ApplicationController
  skip_before_action :ensure_consent_given

  before_action do |controller|
    controller.ensure_logged_in t("layouts.notifications.you_must_log_in_to_view_this_page")
  end

  before_action :ensure_user_is_tutor
  before_action :ensure_correct_step, only: [
    :continue, 
    :registered_oauth, :email_verification_finished, :qualifications,
    :profile_picture, :describe_yourself, :cover_photos,
    :social_media, :id_verification, :payment_information,
    :bizaar_pact,
  ]
  before_action :set_next_step_path

  def continue

  end

  # GET:
  def registered_oauth
    @service = Person::SettingsService.new(community: @current_community, params: params, person: @current_user, current_user: @current_user)
  end

  # GET:
  # show page
  def email_verification_finished
    # this page should be displayed only once
    tutor_status = @current_user.tutor_signup_status
    tutor_status.signup_status = :profile_picture
    tutor_status.save!
  end

  def profile_picture
    @custom_profile = @current_user.custom_profile
  end

  def qualifications

  end

  def describe_yourself

  end

  def cover_photos

  end

  def social_media

  end

  def id_verification

  end

  def payment_information

  end

  def bizaar_pact

  end

private

  def ensure_user_is_tutor
    unless @current_user.is_tutor?
      flash[:error] = 'You should be a tutor to access this page'
      redirect_to login_path
    end
  end

  def ensure_correct_step

    # ToDo: temporary workaround for frontend dev
    return if params['force_display_page']

    tutor_status = @current_user.tutor_signup_status
    tutor_status.next_step_if_complete!
    tutor_status_name = tutor_status.signup_status

    if tutor_status_name.to_s != action_name.to_s
      # redirect_to action: tutor_status_name.to_sym
      redirect_to public_send("tutor_wizard_#{tutor_status_name}_path")
    end

  end

  def set_next_step_path
    next_step_name = @current_user.tutor_signup_status.next_step_name
    @next_step_path = next_step_name ? "tutor_wizard_#{next_step_name}_path" : "search_path"
  end

end

