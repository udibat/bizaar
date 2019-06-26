class AddIsPrimaryToCoverPhotos < ActiveRecord::Migration[5.1]
  def change
    add_column :cover_photos, :is_primary_photo, :boolean, default: false
  end
end

