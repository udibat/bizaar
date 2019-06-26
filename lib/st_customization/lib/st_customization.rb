require "st_customization/engine"
require 'st_customization/railtie' if defined?(Rails)

ActionController::Base.view_paths = [
      # Rails.root.join('lib', 'st_customization', 'app', 'views'),
      Rails.root.to_s + "/lib/st_customization/app/views/",
      Rails.root.to_s + "/app/views/"
    ]

module StCustomization
  # Your code goes here...
end

