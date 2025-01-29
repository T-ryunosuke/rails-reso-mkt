# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# CitiesとItemsの情報がすでに存在している前提
cities = City.all
items = Item.all

# 価格データを作成
cities.each do |city|
  items.each do |item|
    # ランダムな価格割合（100%を基準にして±10%の範囲）
    price_percentage = rand(90..110)

    # ランダムに動向を決定（true: 上昇, false: 下降）
    trend = [ true, false ].sample

    # 価格データを作成
    Price.create!(
      city_id: city.id,
      item_id: item.id,
      price_percentage: price_percentage,
      trend: trend
    )
  end
end
puts "価格データが作成されました。"
