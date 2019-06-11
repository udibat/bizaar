module StCustomization
  # @private
  class Railtie < Rails::Railtie
    initializer "st_customization.configure_rails_initialization" do |app|
      app.middleware.use JQuery::FileUpload::Rails::Middleware
    end
  end

end

