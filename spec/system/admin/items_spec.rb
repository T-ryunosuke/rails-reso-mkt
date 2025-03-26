require 'rails_helper'

RSpec.describe "管理者用ページ：商品", type: :system do
  let(:correct_password) { ENV['AUTH_PASSWORD'] }
  let!(:item) { create(:item, name: "カメラ") }

  before do
    # 事前に認証を通す
    visit login_path
    fill_in "パスワード", with: correct_password
    click_button "ログイン"

    # 認証後にCities一覧へ遷移
    visit items_path
  end

  it "都市を削除できること" do
    expect(page).to have_content("カメラ")

    accept_confirm do
      click_link "削除"
    end

    expect(page).to have_no_content("カメラ")
    expect(page).to have_content("削除しました。")
  end
end
