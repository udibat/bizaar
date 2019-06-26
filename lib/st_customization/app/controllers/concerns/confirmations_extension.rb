require 'active_support/concern'

module ConfirmationsExtension
  extend ActiveSupport::Concern

  included do

    after_action :update_tutor_signup_status, only: [:show]

    alias_method :show_before_redef, :show
    def show
      # Override default redirect after successfull confirmation
      # session[:return_to] = custom_routes.tutor_wizard_continue_path
      # 6Kwfsy0XjInvc2hg
      if @current_user.is_tutor?
        session[:return_to] = tutor_wizard_continue_path
      else
        session[:return_to] = member_wizard_continue_path
      end
      
      # store target email:
      email = Email.find_by_confirmation_token(params[:confirmation_token])
      params[:processed_email_id] = email.id if email

      show_before_redef
    end

  end

  # class_methods do

  # end

private
  def update_tutor_signup_status
    email = Email.find_by_id(params[:processed_email_id])
    if email && email.confirmed_at
      signup_status = if @current_user.is_tutor?
        @current_user.tutor_signup_status
      else
        @current_user.member_signup_status
      end

      signup_status.signup_status = :email_verification_finished
      signup_status.save!

      # we'll use our own less strict consent logic
      @current_user.skip_st_consent!

    end
  end

end

