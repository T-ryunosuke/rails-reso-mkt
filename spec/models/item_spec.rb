require "rails_helper"

RSpec.describe Item, type: :model do
  describe "関係" do
    it { should have_many(:prices) }
    it { should have_many(:cities).through(:prices) }
  end

  describe "バリデーションの存在確認" do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end

  describe "バリデーション" do
    let(:item) { build(:item, name: nil) }
    it "nameが空の場合にエラー" do
      expect(item).not_to be_valid
      expect(item.errors[:name]).to include("can't be blank")
    end
  end
end
