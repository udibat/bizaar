class AddVerifiedFieldsToCustomProfile < ActiveRecord::Migration[5.1]
  def change
    add_column :custom_profiles, :id_verified, :boolean, default: false
    add_column :custom_profiles, :cert_verified, :boolean, default: false
  end
end

