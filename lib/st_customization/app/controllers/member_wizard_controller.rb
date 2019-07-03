# ToDo: Refcator to avoid member_*/tutor_* copy-paste
class MemberWizardController < ApplicationController
   #< PaymentSettingsController
  skip_before_action :ensure_consent_given

  # this will be inherited from parent class
  before_action do |controller|
    controller.ensure_logged_in t("layouts.notifications.you_must_log_in_to_view_this_page")
  end

  # skip_before_action :ensure_payments_enabled, except: [:index, :create, :update]
  # skip_before_action :warn_about_missing_payment_info, except: [:index, :update]
  # skip_before_action :load_stripe_account, except: [:index, :create, :update]

  # include AllowTutorOnly

  before_action :ensure_correct_step, only: [
    :continue, 
    :registered_oauth, :email_verification_finished,
    # :qualifications,
    :setup_profile,
    # :describe_yourself, :cover_photos,
    # :social_media, :id_verification, 
    :payment_information,
    :bizaar_pact, :finished
  ]
  before_action :set_next_step_path, only: [
    :setup_profile, :payment_information, :bizaar_pact
  ]
  before_action :load_profile, :load_signup_status, only: [
    # :qualifications,
    :setup_profile,
    :payment_information,
    # :describe_yourself, :cover_photos,
    # :social_media, :id_verification, 
    # :index, :update, :create, 
    :bizaar_pact
  ]

  def continue

  end

  def confirm_step
    new_step_name = @current_user.member_signup_status.
      next_step_if_complete!(params['step_name'])

    new_step_url = public_send("member_wizard_#{new_step_name}_url") if new_step_name.present?

    render json: {
      success: new_step_name.present?,
      new_step_url: new_step_url
    }
  end

  def skip_step
    @current_user.member_signup_status.try_skip_step!(params['skip_step_name'])

    redirect_to member_wizard_continue_path
  end

  def backward_step
    prev_step_name = @current_user.member_signup_status.prev_step!

    prev_step_url = public_send("member_wizard_#{prev_step_name}_url") if prev_step_name.present?

    render json: {
      success: prev_step_name.present?,
      new_step_url: prev_step_url
    }
  end

  # GET:
  def registered_oauth
    @service = Person::SettingsService.new(community: @current_community, params: params, person: @current_user, current_user: @current_user)
  end

  # GET:
  # show page
  def email_verification_finished
    # this page should be displayed only once
    member_status = @current_user.member_signup_status
    member_status.signup_status = :setup_profile
    member_status.save!
  end

  def setup_profile

  end

  def payment_information
    @existing_cards = CustomStripeUtils.list_customer_payment_cards(@current_user, @current_community)
  end

  def bizaar_pact

  end

  def finished
    flash[:notice] = 'Congratulations! Your profile is complete now!'
    redirect_to search_path
  end

private

  def index_view_locals
    {index_view_locals: super}
  end

  def load_profile
    @custom_profile = @current_user.custom_profile
  end

  def load_signup_status
    @member_status ||= @current_user.member_signup_status
  end

  def ensure_correct_step
    @member_status = @current_user.member_signup_status

    # ToDo: temporary workaround for frontend dev
    if params['force_display_page']
      if MemberSignupStatus.signup_statuses[action_name.to_s].is_a?(Integer)
        @member_status.signup_status = action_name.to_sym
        @member_status.save!
      end
      
      return
    end

    
    curr_step_idx = MemberSignupStatus.signup_statuses[@member_status.signup_status.to_s]
    requested_step_idx = MemberSignupStatus.signup_statuses[action_name.to_s]

    # @tutor_status.next_step_if_complete!
    member_status_name = @member_status.signup_status

    if member_status_name.to_s != action_name.to_s
      # redirect_to action: tutor_status_name.to_sym
      redirect_to public_send("member_wizard_#{member_status_name}_path")
    end

  end

  def set_next_step_path
    curr_step_name = @current_user.member_signup_status.signup_status
    next_step_name = @current_user.member_signup_status.next_step_name
    @next_step_path = next_step_name ? "member_wizard_#{next_step_name}_path" : "search_path"
    @next_step_path = public_send(@next_step_path)

    @prev_step_path = member_wizard_backward_step_path

    @confirm_step_path = member_wizard_confirm_step_path(curr_step_name, {nocache: Time.now.to_i})
  end

end

