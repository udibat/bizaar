class AddRatingCacheToListing < ActiveRecord::Migration[5.1]
  def up
    blank = { count: 0, avg: 0 }.to_yaml
    add_column :listings, :rating_cache, :string, default: blank
    Listing.find_each do |listing|
      listing.reset_rating_cache!
    end
  end

  def down
    remove_column :listings, :rating_cache
  end
end
