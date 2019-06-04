class CreateTutorSignupStatuses < ActiveRecord::Migration[5.1]
  def change
    create_table :tutor_signup_statuses do |t|
      t.references :person, index: true
      t.integer :signup_status, default: 0


      t.timestamps
    end

  end
end

