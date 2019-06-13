class AddCatRefToCertifications < ActiveRecord::Migration[5.1]
  def change
    remove_column :certifications, :category
    add_column :certifications, :category_id, :integer
    add_index :certifications, :category_id, unique: false
    add_foreign_key :certifications, :categories
  end
end

