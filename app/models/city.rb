class City < ApplicationRecord
  has_many :prices
  has_many :items, through: :prices

  validates :name, presence: true, uniqueness: true
end
