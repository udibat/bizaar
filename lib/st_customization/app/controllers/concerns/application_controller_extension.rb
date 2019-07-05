require 'active_support/concern'

module ApplicationControllerExtension
  extend ActiveSupport::Concern

  included do

    # consent step now swallowed up by extended signup process
    def ensure_consent_given

      # Not logged in
      return unless @current_user

      # Admin can access
      return if @current_user.has_admin_rights?(@current_community)

      # default consent field now set to true on signup for all registered users
      # if @current_user.community_membership.pending_consent?
      #   redirect_to pending_consent_path
      # end

      unless @current_user.signup_process_complete?
        wizard_continue_path =  if @current_user.is_tutor?
          tutor_wizard_continue_path
        else
          member_wizard_continue_path
        end

        redirect_to wizard_continue_path
      end

    end

  end

  # class_methods do

  # end

# private

end

