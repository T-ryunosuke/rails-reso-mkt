class Price < ApplicationRecord
  belongs_to :city
  belongs_to :vegetable
end
