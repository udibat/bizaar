class CreateIdVerificationImages < ActiveRecord::Migration[5.1]
  def change
    create_table :id_verifications do |t|
      t.references :custom_profile, index: true

      t.timestamps
    end

    add_attachment :id_verifications, :image

  end
end
