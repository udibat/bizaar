class AddStatusToCertifications < ActiveRecord::Migration[5.1]
  def change
    add_column :certifications, :status, :integer, default: 0
    add_column :certifications, :status_updated_at, :datetime, null: true
    add_column :certifications, :status_updated_by, :string, null: true
    add_column :certifications, :rejection_reason, :string, null: true
  end
end

