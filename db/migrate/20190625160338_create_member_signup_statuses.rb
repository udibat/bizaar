class CreateMemberSignupStatuses < ActiveRecord::Migration[5.1]
  def change
    create_table :member_signup_statuses do |t|
      t.string :person_id, null: false
      t.integer :signup_status, default: 0


      t.timestamps
    end
    
    add_index :member_signup_statuses, :person_id, unique: true
  end
end
