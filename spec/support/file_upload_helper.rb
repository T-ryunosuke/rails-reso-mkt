# 引数で渡されるfilenameに基づいてファイルパスを生成してテスト環境でファイルアップロードをシミュレートするヘルパーメソッドを提供するモジュール
module FileUploadHelper
  # 指定されたCSVファイルをアップロード用に準備するヘルパーメソッド
  def uploaded_csv_file(filename)
    Rack::Test::UploadedFile.new(Rails.root.join("spec", "fixtures", "files", filename), "text/csv")
  end

  # 指定されたtextファイルをアップロード用に準備するヘルパーメソッド
  def uploaded_non_csv_file(filename)
    Rack::Test::UploadedFile.new(Rails.root.join("spec", "fixtures", "files", filename), "text/plain")
  end
end
