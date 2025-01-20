require "rails_helper"

RSpec.describe City, type: :model do
  describe "関係" do
    it { should have_many(:prices) }
    it { should have_many(:items).through(:prices) }
  end

  describe "バリデーションの存在確認" do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end

  describe "バリデーション" do
    let(:city) { build(:city, name: nil) }
    it "nameが空の場合にエラー" do
      expect(city).not_to be_valid
      expect(city.errors[:name]).to include("can't be blank")
    end
  end
end
