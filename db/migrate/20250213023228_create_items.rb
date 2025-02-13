class CreateItems < ActiveRecord::Migration[7.2]
  def change
    create_table :items do |t|
      t.string :name, null: false
    end

    # nameカラムにインデックスを追加
    add_index :items, :name
  end
end
