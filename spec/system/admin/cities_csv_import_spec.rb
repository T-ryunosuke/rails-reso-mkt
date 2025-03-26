require 'rails_helper'

# コントローラーテストでは事前に用意した固定の CSV を使う方が、テストの再現性が高く便利。
# しかしシステムテストで spec/fixtures に保存された CSV を使うには、事前にテスト環境へコピーする手間が発生する。
# Tempfile を使うことで、テスト毎に新しい CSV を作成でき、環境に依存せずに動作する。

RSpec.describe "都市のCSVインポート", type: :system do
  let(:correct_password) { ENV['AUTH_PASSWORD'] }

  before do
    # 事前に認証を通す
    visit login_path
    fill_in "パスワード", with: correct_password
    click_button "ログイン"

    # 認証後にCities一覧へ遷移
    visit cities_path
  end

  it "正しいCSVをアップロードするとデータがインポートされる" do
    # テスト用CSVファイルを作成
    # Tempfile は一時ファイルを作成・管理するためのクラス
    # File.write ではなく Tempfile を使うことで自動削除されるので、後処理を忘れる心配がない。
    Tempfile.create([ "test", ".csv" ]) do |csv|
      csv.write("name\nTokyo\nOsaka\nNagoya\n")
      csv.rewind

      expect(page).to have_selector("input[type='file']")
      attach_file "file", csv.path
      click_button "取り込み"
    end

    expect(page).to have_content("CSVのデータをインポートしました。")
    expect(page).to have_content("Tokyo")
    expect(page).to have_content("Osaka")
    expect(page).to have_content("Nagoya")
  end

  it "CSVの形式が不正な場合、エラーメッセージが表示される" do
    Tempfile.create([ "invalid", ".csv" ]) do |csv|
      csv.write("city\nTokyo\nOsaka\n")
      # ポインタを先頭に
      csv.rewind

      attach_file "file", csv.path
      click_button "取り込み"
    end

    expect(page).to have_content("CSVファイルの１行目は「name」にしてください。")
  end


  it "CSV形式ではないファイルをアップロードするとエラーメッセージが表示される" do
    Tempfile.create([ "test", ".txt" ]) do |txt|
      txt.write("txtファイルです。")
      txt.rewind

      attach_file "file", txt.path
      click_button "取り込み"
    end

    expect(page).to have_content("CSV形式のファイルをアップロードしてください。")
  end

  it "ファイルを選択せずにアップロードすると警告が表示される" do
    click_button "取り込み"

    expect(page).to have_content("ファイルが選択されていません。")
  end
end
