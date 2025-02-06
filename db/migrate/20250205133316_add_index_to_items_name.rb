class AddIndexToItemsName < ActiveRecord::Migration[7.2]
  def change
    add_index :items, :name
  end
end
