class MemberWizardController < PaymentSettingsController
  skip_before_action :ensure_consent_given

  # this will be inherited from parent class
  # before_action do |controller|
  #   controller.ensure_logged_in t("layouts.notifications.you_must_log_in_to_view_this_page")
  # end

  skip_before_action :ensure_payments_enabled, except: [:index, :create, :update]
  skip_before_action :warn_about_missing_payment_info, except: [:index, :update]
  skip_before_action :load_stripe_account, except: [:index, :create, :update]

  # include AllowTutorOnly

  # before_action :ensure_correct_step, only: [
  #   :continue, 
  #   :registered_oauth, :email_verification_finished, :qualifications,
  #   :profile_picture, :describe_yourself, :cover_photos,
  #   :social_media, :id_verification, :index,
  #   :bizaar_pact, :finished
  # ]
  # before_action :set_next_step_path
  before_action :load_profile, :load_signup_status, only: [
    # :qualifications,
    :setup_profile, 
    # :describe_yourself, :cover_photos,
    # :social_media, :id_verification, 
    :index, :update, :create, 
    :bizaar_pact
  ]

  def continue

  end

  def confirm_step
    new_step_name = @current_user.tutor_signup_status.
      next_step_if_complete!(params['step_name'])

    new_step_url = public_send("tutor_wizard_#{new_step_name}_url") if new_step_name.present?

    render json: {
      success: new_step_name.present?,
      new_step_url: new_step_url
    }
  end

  def skip_step
    @current_user.tutor_signup_status.try_skip_step!(params['skip_step_name'])

    redirect_to tutor_wizard_continue_path
  end

  def backward_step
    prev_step_name = @current_user.tutor_signup_status.prev_step!

    prev_step_url = public_send("tutor_wizard_#{prev_step_name}_url") if prev_step_name.present?

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
    member_status.signup_status = :profile_picture
    member_status.save!
  end

  def setup_profile

  end

  def qualifications
    @existing_certifications = CertificationWizardDecorator.decorate_collection(
      @custom_profile.certifications).to_a
    @new_certification = @custom_profile.certifications.build
  end

  def describe_yourself

  end

  def cover_photos
    @custom_profile.cover_photos.build
  end

  def social_media

  end

  def id_verification
    @custom_profile.id_verifications.build
  end

  # use inherited `index` action from payments controller
  # def payment_information
  #   render 'payment_information', locals: {index_view_locals: index_view_locals}
  # end

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
    # after reaching the current step page, `free_navigation` param should disappear
    if params['free_navigation'] == 'true' && requested_step_idx == curr_step_idx
      params.delete('free_navigation')
      return
    end

    @free_navigation_mode = params['free_navigation'] == 'true'
    
    # allow free navigation to previous steps, but not new steps
    return if @free_navigation_mode && requested_step_idx < curr_step_idx

    # @tutor_status.next_step_if_complete!
    member_status_name = @member_status.signup_status

    if member_status_name.to_s != action_name.to_s
      # redirect_to action: tutor_status_name.to_sym
      redirect_to public_send("member_wizard_#{member_status_name}_path")
    end

  end

  def set_next_step_path
    custom_step = @free_navigation_mode ? action_name : nil
    curr_step_name = custom_step || @current_user.tutor_signup_status.signup_status
    next_step_name = @current_user.tutor_signup_status.next_step_name(custom_step)
    @next_step_path = next_step_name ? "tutor_wizard_#{next_step_name}_path" : "search_path"
    @next_step_path = public_send(@next_step_path)

    @prev_step_path = tutor_wizard_backward_step_path

    @confirm_step_path = tutor_wizard_confirm_step_path(curr_step_name, {nocache: Time.now.to_i})
  end

end

