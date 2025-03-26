require 'rails_helper'

RSpec.describe "管理者用ページ：商品", type: :system do
  let(:correct_password) { ENV['AUTH_PASSWORD'] }

  before do
    # 事前に認証を通す
    visit login_path
    fill_in "パスワード", with: correct_password
    click_button "ログイン"

    # 認証後にCities一覧へ遷移
    visit new_price_path
  end

  it "新しい価格データが追加される" do
    # テスト前にデータがないことを確認
    expect(Price.count).to eq(0)

    # FactoryBotで必要なデータを作成
    city = create(:city)
    item = create(:item)

    click_button "新規追加"

    # 存在の確認
    expect(Price.count).to be > 0

    # FactoryBotで作られたcityとitemを元にデータが作られているかを確認
    price = Price.find_by(city_id: city.id, item_id: item.id)
    expect(price).to be_present
    expect(price.city.name).to eq("東京")
    expect(price.item.name).to eq("カメラ")

    expect(page).to have_content("新しい価格データを追加しました。")
  end

  it "追加する価格データがない場合、警告メッセージが表示される" do
    # 都市データがない場合
    allow(City).to receive(:all).and_return([])
    # 商品データがない場合
    allow(Item).to receive(:all).and_return([])

    click_button "新規追加"

    expect(page).to have_content("追加できる価格データがありません。")
  end
end
