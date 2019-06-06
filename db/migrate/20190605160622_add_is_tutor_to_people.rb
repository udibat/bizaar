class AddIsTutorToPeople < ActiveRecord::Migration[5.1]
  def change
    add_column :people, :is_tutor, :boolean, default: false
  end
end

