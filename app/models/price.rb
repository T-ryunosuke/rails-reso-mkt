class Price < ApplicationRecord
  belongs_to :city
  belongs_to :item

  validates :price_percentage, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 80, less_than_or_equal_to: 150 }
  validates :trend, inclusion: { in: [ true, false ] }

  def self.ransackable_attributes(auth_object = nil)
    [ "city_id", "created_at", "id", "item_id", "price_percentage", "trend", "updated_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "city", "item" ]
  end
end
