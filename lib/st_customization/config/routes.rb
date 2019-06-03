Rails.application.routes.draw do
  devise_scope :person do
    # List few specific routes here for Devise to understand those
    # get "/signup" => "people#new1", :as => :sign_up1

  end
end

# Rails.application.routes_reloader.route_sets.last.named_routes.to_a[300]
# http://www.brice-sanchez.com/til-how-to-override-spree-rails-engine-routes/

