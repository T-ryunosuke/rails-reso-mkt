class CitiesController < CsvImportController
  def index
    @cities = City.all
  end
end
