class Price < ApplicationRecord
  after_update_commit -> { broadcast_replace_to "prices" }


  belongs_to :city
  belongs_to :item

  validates :price_percentage, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 80 }
  validates :trend, inclusion: { in: [true, false] }
end
