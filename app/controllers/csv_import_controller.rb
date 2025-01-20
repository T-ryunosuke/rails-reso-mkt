class CsvImportController < ApplicationController
  require "csv"

  def import
    # モデルに応じたインスタンス変数を取得
    instance_name = controller_name.singularize.capitalize.constantize
    instance_variable_set("@#{controller_name}", instance_name.all)

    # ファイルが送られてきているかチェック
    if params[:file].present?
      file = params[:file]

      # ファイルの拡張子をチェック
      unless file.original_filename.match?(/\.csv\z/i)
        set_flash_and_render(:error, "CSV形式のファイルをアップロードしてください。")
        return
      end

      begin
        # CSVの各行を処理
        CSV.foreach(file.path, headers: true, encoding: "UTF-8") do |row|
          if row["name"].present?
            instance_name.find_or_create_by(name: row["name"])
          else
            set_flash_and_render(:error, "CSVファイルの１行目は「name」にしてください。")
            return
          end
        end
        redirect_to controller_name.pluralize.to_sym, success: "CSVのデータをインポートしました。"
      rescue CSV::MalformedCSVError => e
        set_flash_and_render(:error, "CSVファイルの形式が正しくありませんでした： #{e.message}")
      end
    else
      set_flash_and_render(:info, "ファイルが選択されていません。")
    end
  end

  private

  # flashメッセージとrenderを共通化するヘルパーメソッド
  def set_flash_and_render(type, message)
    flash.now[type] = message
    render :index, status: :unprocessable_entity
  end
end
