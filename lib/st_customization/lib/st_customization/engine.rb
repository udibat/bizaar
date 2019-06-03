
module StCustomization
  class Engine < ::Rails::Engine

    config.to_prepare do
      Rails.logger.debug "RELOADING StCustomization"
      require_dependency StCustomization::Engine.root.join('lib', 'st_customization').to_s

      # require_dependency Rails.root.to_s + '/lib/st_customization/app/controllers/concerns/signup_extension'
      PeopleController.send(:include, ::SignupExtension)

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
