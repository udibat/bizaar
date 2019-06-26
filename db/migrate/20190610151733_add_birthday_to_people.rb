class AddBirthdayToPeople < ActiveRecord::Migration[5.1]
  def change
    add_column :people, :birthday, :date
  end
end

