class CreateCoverPhotos < ActiveRecord::Migration[5.1]
  def change
    create_table :cover_photos do |t|
      t.references :custom_profile, index: true

      t.timestamps
    end

    add_attachment :cover_photos, :image

  end
end
