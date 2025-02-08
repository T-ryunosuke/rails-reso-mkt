class CreatePrices < ActiveRecord::Migration[7.2]
  def change
    create_table :prices do |t|
      t.references :city, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true
      t.integer :price_percentage, null: false
      t.boolean :trend, null: false

      t.timestamps
    end

    # "updated_at"と"price_percentage"にインデックスを追加
    add_index :prices, [:updated_at, :price_percentage], order: { updated_at: :desc, price_percentage: :desc }, name: "index_prices_on_updated_at_and_price_percentage"
  end
end
