
module StCustomization
  class Engine < ::Rails::Engine

    config.to_prepare do
      Rails.logger.debug "RELOADING StCustomization"
      require_dependency StCustomization::Engine.root.join('lib', 'st_customization').to_s

      # require_dependency Rails.root.to_s + '/lib/st_customization/app/controllers/concerns/signup_extension'
      # ToDo: automate this
      ApplicationController.send(:include, ApplicationControllerExtension)
      PeopleController.send(:include, PeopleControllerExtension)
      ConfirmationsController.send(:include, ::ConfirmationsExtension)
      Person.send(:include, PersonExtension)
      OmniauthController.send(:include, OmniauthTutorExtension)
      SettingsController.send(:include, SettingsControllerExtension)
      HomepageController.send(:include, HomepageControllerExtension)
      TestimonialsController.send(:include, TestimonialsControllerExtension)
      TopbarHelper.send(:include, TopbarHelperExtension)

      # the following is unstable (causing routes drawing fails on `reload!`), 
      # additional ivestigating required
      # Rails.application.routes.prepend do
      #   mount StCustomization::Engine => "/"
      # end

    end

    # if Rails.env.development?
    #   config.after_initialize do
    #     # optional, without it will call `to_prepend` only when a file changes,
    #     # not on every request
    #     Rails.application.config.reload_classes_only_on_change = false
    #   end
    # end
  end
end

