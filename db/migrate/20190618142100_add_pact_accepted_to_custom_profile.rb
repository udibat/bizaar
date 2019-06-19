class AddPactAcceptedToCustomProfile < ActiveRecord::Migration[5.1]
  def change
    add_column :custom_profiles, :pact_accepted, :boolean, default: false
  end
end
