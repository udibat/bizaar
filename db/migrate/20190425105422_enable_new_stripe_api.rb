class EnableNewStripeApi < ActiveRecord::Migration[5.1]
  def change
    FeatureFlagService::API::Api.features.enable(community_id: 1, features: [:new_stripe_api])
  end
end
