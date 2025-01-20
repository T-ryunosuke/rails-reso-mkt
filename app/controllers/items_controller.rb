class ItemsController < CsvImportController
  def index
    @items = Item.all
  end
end
