class ItemsController < ApplicationController
  require "csv"

  def index
    @items = Item.all
  end

  def import
    # アップロード失敗時に@citiesを渡すため
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
          Item.find_or_create_by(name: row["name"])
        else
          flash.now[:error] = "CSVファイルの１行目は「name」にしてください。"
          return render :index, status: :unprocessable_entity
        end
      end
      redirect_to items_path, success: "CSVのデータをインポートしました。"
    else
      flash.now[:info] = "CSVファイルを選択してください。"
      render :index, status: :unprocessable_entity
    end
  end
end
