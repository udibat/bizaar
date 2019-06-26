class AddSocialFieldsToCustomProfile < ActiveRecord::Migration[5.1]
  def change
    add_column :custom_profiles, :social_link_facebook, :string
    add_column :custom_profiles, :social_link_twitter, :string
    add_column :custom_profiles, :social_link_instagram, :string
    add_column :custom_profiles, :social_link_youtube, :string
    add_column :custom_profiles, :social_link_twitch, :string
    add_column :custom_profiles, :social_link_vimeo, :string
  end
end

