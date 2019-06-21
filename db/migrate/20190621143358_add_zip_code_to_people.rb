class AddZipCodeToPeople < ActiveRecord::Migration[5.1]
  def change
    add_column :people, :zip_code, :string
  end
end

