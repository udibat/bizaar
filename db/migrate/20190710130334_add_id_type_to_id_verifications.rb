class AddIdTypeToIdVerifications < ActiveRecord::Migration[5.1]
  def change
    add_column :id_verifications, :identification_type, :string, null: true
  end
end
