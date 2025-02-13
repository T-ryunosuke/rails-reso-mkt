class CreateInterests < ActiveRecord::Migration[7.2]
  def change
    create_table :interests do |t|
      # 外部キー price_id を設定
      t.references :price, null: false, foreign_key: true, type: :bigint
      t.timestamps
    end
  end
end
