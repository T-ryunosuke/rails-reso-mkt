class CitiesController < ApplicationController
  require "csv"

  def index
    @cities = City.all
  end

  def import
    @cities = City.all
    if params[:file].present?
      file = params[:file]

      # ファイルの拡張子をチェック
      if !file.original_filename.match?(/\.csv\z/i)
        flash.now[:error] = "CSVファイルをアップロードしてください。"
        return render :index, status: :unprocessable_entity
      end

      CSV.foreach(file.path, headers: true, encoding: "UTF-8") do |row|
        if row["name"].present?
          City.find_or_create_by(name: row["name"])
        else
          flash.now[:error] = "CSVファイルの１行目は「name」にしてください。"
          return render :index, status: :unprocessable_entity
        end
      end
      redirect_to cities_path, success: "CSVのデータをインポートしました。"
    else
      flash.now[:info] = "CSVファイルを確認できませんでした"
      render :index, status: :unprocessable_entity
    end
  end
end
