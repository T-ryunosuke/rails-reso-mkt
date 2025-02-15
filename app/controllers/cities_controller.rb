class CitiesController < CsvImportController
  def index
    @cities = City.all
  end

  def destroy
    @city = City.find(params[:id])
    @city.destroy
    flash.now[:success] = "削除しました。"
  end
end
