require 'active_support/concern'

module ConfirmationsExtension
  extend ActiveSupport::Concern

  included do

    alias_method :show_before_redef, :show
    def show
      # Override default redirect after successfull confirmation
      session[:return_to] = custom_routes.tutor_wizard_continue_path

      if @current_user.is_tutor?
        @current_user.tutor_signup_status.next_step!
      end

      show_before_redef
    end

  end

  # class_methods do

  # end

end

