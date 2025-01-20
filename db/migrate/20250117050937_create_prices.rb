class CreatePrices < ActiveRecord::Migration[7.2]
  def change
    create_table :prices do |t|
      t.references :city, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true
      t.integer :price_percentage, null: false
      t.boolean :trend, null: false

      t.timestamps
    end
  end
end
