# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

require "csv"

# CSVファイルのディレクトリ
csv_dir = Rails.root.join("lib", "csv_files")

# Citiesデータの作成
cities_csv = csv_dir.join("cities.csv")
if File.exist?(cities_csv)
  CSV.foreach(cities_csv, headers: true, encoding: "UTF-8") do |row|
    if row["name"].present?
      City.find_or_create_by(name: row["name"])
    end
  end
  puts "Citiesデータ作成成功"
else
  puts "Citiesデータ作成失敗"
end

# Itemsデータの作成
items_csv = csv_dir.join("items.csv")
if File.exist?(items_csv)
  CSV.foreach(items_csv, headers: true, encoding: "UTF-8") do |row|
    if row["name"].present?
      Item.find_or_create_by(name: row["name"])
    end
  end
  puts "Itemsデータ作成完了"
else
  puts "Itemsデータ作成失敗"
end

# Pricesデータの作成
cities = City.all
items = Item.all

cities.each do |city|
  items.each do |item|
    # ランダムな価格割合（100%を基準にして±10%の範囲）
    price_percentage = rand(90..110)
    # ランダムに動向を決定（true: 上昇, false: 下降）
    trend = [ true, false ].sample

    Price.create!(
      city_id: city.id,
      item_id: item.id,
      price_percentage: price_percentage,
      trend: trend
    )
  end
end

puts "価格データが作成されました。"
