class CreateCertifications < ActiveRecord::Migration[5.1]
  def change
    create_table :certifications do |t|
      t.references :custom_profile
      t.string :name
      t.integer :category

      t.timestamps
    end

    add_attachment :certifications, :image

  end
end
