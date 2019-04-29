class AddSearchKey < ActiveRecord::Migration[5.1]
  def change
    MarketplaceConfigurations.update_all(main_search: 'keyword_and_location', limit_search_distance: 1)
  end
end
