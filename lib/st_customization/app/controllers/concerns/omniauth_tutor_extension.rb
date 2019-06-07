require 'active_support/concern'

module OmniauthTutorExtension
  extend ActiveSupport::Concern

  included do

    private

    def create_omniauth
      origin_locale = get_origin_locale(request, available_locales())
      I18n.locale = origin_locale if origin_locale
  
      service = Person::OmniauthService.new(
        community: @current_community,
        request: request,
        logger: logger)
  
      if service.person
        service.update_person_provider_uid
        flash[:notice] = t("devise.omniauth_callbacks.success", kind: service.provider_name)
        sign_in_and_redirect service.person, :event => :authentication
      elsif service.no_ominauth_email?
        flash[:error] = t("layouts.notifications.could_not_get_email_from_social_network", provider: service.provider_name)
        redirect_to sign_up_path and return
      elsif service.person_email_unconfirmed
        flash[:error] = t("layouts.notifications.social_network_email_unconfirmed", email: service.email, provider: service.provider_name)
        redirect_to tutor_wizard_continue_path and return
      else
        @new_person = service.create_person

        # Mark newly created person as Tutor:
        @new_person.mark_as_tutor!

        tutor_signup_status = @new_person.tutor_signup_status
        tutor_signup_status.signup_status = :registered_oauth
        tutor_signup_status.save!

        
        # we'll use our own less strict consent logic
        @new_person.skip_st_consent!
  
        sign_in(:person, @new_person)
        flash[:notice] = t("layouts.notifications.login_successful", person_name: view_context.link_to(PersonViewUtils.person_display_name_for_type(@new_person, "first_name_only"), person_path(@new_person))).html_safe # rubocop:disable Rails/OutputSafety
  
  
        session[:fb_join] = "pending_analytics"
  
        record_event(flash, "SignUp", method: service.provider.to_sym)
  
        redirect_to tutor_wizard_continue_path
      end
    end
  end

  # class_methods do

  # end

end

