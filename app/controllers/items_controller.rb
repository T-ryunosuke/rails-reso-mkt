class ItemsController < ApplicationController
  require 'csv'

  def index
    @items = Item.all
  end

  def import
    if params[:file].present?
      file = params[:file]
      CSV.foreach(file.path, headers: true, encoding: 'UTF-8') do |row|
        Item.find_or_create_by(name: row['name'])
      end
      redirect_to items_path
    else
      redirect_to items_path
    end
  end
end
