class PricesController < ApplicationController
  def index
    @prices = Price.includes(:city, :item).all
  end

  def select_city
    @cities = City.all
  end
end
