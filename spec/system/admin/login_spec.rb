require 'rails_helper'

RSpec.describe "管理者ログイン", type: :system do
  let(:correct_password) { ENV['AUTH_PASSWORD'] }
  let(:wrong_password) { 'wrong-password' }


  it "正しいパスワードでログインできる" do
    visit login_path

    fill_in "パスワード", with: correct_password
    click_button "ログイン"

    expect(page).to have_current_path(cities_path)
    expect(page).to have_content("ログインしました")
  end
end
