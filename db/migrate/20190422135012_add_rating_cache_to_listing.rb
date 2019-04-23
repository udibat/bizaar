class AddRatingCacheToListing < ActiveRecord::Migration[5.1]
  def up
    blank = { count: 0, avg: 0 }.to_yaml
    add_column :people, :rating_cache, :string, default: blank
    Person.find_each do |person|
      person.reset_rating_cache!
    end
  end

  def down
    remove_column :people, :rating_cache
  end
end
