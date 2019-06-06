require 'active_support/concern'

module ConfirmationsExtension
  extend ActiveSupport::Concern

  included do

    after_action :update_tutor_signup_status, only: [:show]

    alias_method :show_before_redef, :show
    def show
      # Override default redirect after successfull confirmation
      session[:return_to] = custom_routes.tutor_wizard_continue_path
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
    if @current_user.is_tutor? && email && email.confirmed_at
      tutor_stat = @current_user.tutor_signup_status
      tutor_stat.signup_status = :email_verification_finished
      tutor_stat.save!
    end
  end

end

