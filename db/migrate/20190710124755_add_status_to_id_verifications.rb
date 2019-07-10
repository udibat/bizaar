class AddStatusToIdVerifications < ActiveRecord::Migration[5.1]
  def change
    add_column :id_verifications, :status, :integer, default: 0
    add_column :id_verifications, :status_updated_at, :datetime, null: true
    add_column :id_verifications, :status_updated_by, :string, null: true
    add_column :id_verifications, :rejection_reason, :string, null: true
  end
end
