class CitiesController < ApplicationController
  require "csv"

  def index
    @cities = City.all
  end

  def import
    if params[:file].present?
      file = params[:file]
      CSV.foreach(file.path, headers: true, encoding: "UTF-8") do |row|
        City.find_or_create_by(name: row["name"])
      end
      redirect_to cities_path
    else
      redirect_to cities_path
    end
  end
end
