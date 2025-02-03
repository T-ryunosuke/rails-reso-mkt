class Item < ApplicationRecord
  has_many :prices
  has_many :cities, through: :prices

  validates :name, presence: true, uniqueness: true

  def self.ransackable_attributes(auth_object = nil)
    ["id", "name"]
  end
end
