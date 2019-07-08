class AddStringAddressToPeople < ActiveRecord::Migration[5.1]
  def change
    add_column :people, :string_address, :string
  end
end

