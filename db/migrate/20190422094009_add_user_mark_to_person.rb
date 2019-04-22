class AddUserMarkToPerson < ActiveRecord::Migration[5.1]
  def change
    add_column :people, :mark, :integer
    add_index :people, :mark
  end
end
