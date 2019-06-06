class CreateTutorProfile < ActiveRecord::Migration[5.1]
  def change
    create_table :custom_profiles do |t|
      t.string :person_id, null: false

      t.string :description, null: true

      t.timestamps
    end
    
    add_index :custom_profiles, :person_id, unique: true

    add_attachment :custom_profiles, :avatar

  end
end

