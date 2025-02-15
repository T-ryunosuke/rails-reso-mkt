class ItemsController < CsvImportController
  def index
    @items = Item.all
  end

  def destroy
    @item = Item.find(params[:id])
    @item.destroy
    flash.now[:success] = "削除しました。"
  end
end
