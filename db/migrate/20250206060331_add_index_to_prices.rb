class AddIndexToPrices < ActiveRecord::Migration[7.2]
  def change
    add_index :prices, [ :updated_at, :price_percentage ], order: { updated_at: :desc, price_percentage: :desc }, name: "index_prices_on_updated_at_and_price_percentage"
  end
end
