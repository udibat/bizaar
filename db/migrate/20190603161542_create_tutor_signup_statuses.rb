class CreateTutorSignupStatuses < ActiveRecord::Migration[5.1]
  def change
    create_table :tutor_signup_statuses do |t|
      # t.references :person, index: true
      t.string :person_id, null: false
      t.integer :signup_status, default: 0


      t.timestamps
    end

    add_index :tutor_signup_statuses, :person_id, unique: true

  end
end

