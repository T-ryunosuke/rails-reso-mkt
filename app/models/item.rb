class Item < ApplicationRecord
  has_many :prices
  has_many :cities, through: :prices
end
