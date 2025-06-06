require "rails_helper"

RSpec.describe ItemsController, type: :controller do
  describe "CSVアップロード" do
    # FileUploadHelperを使用
    let(:valid_file) { uploaded_csv_file("test.csv") }
    let(:non_csv_file) { uploaded_non_csv_file("not_a_csv.txt") }
    let(:invalid_file) { uploaded_csv_file("invalid.csv") }
    let(:malform_file) { uploaded_csv_file("malform.csv") }

    it "CSVデータ取り込み成功" do
      post :import, params: { file: valid_file }
      expect(response).to redirect_to(items_path)
      expect(flash[:success]).to eq("CSVのデータをインポートしました。")
    end

    context "CSVデータ取り込み失敗" do
      it "ファイルが選択されていない場合" do
        post :import, params: {}
        expect(flash.now[:info]).to eq("ファイルが選択されていません。")
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "CSV形式ではなかった場合" do
        post :import, params: { file: non_csv_file }
        expect(flash.now[:error]).to eq("CSV形式のファイルをアップロードしてください。")
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "CSVデータの１行目に「name」がない場合" do
        post :import, params: { file: invalid_file }
        expect(flash.now[:error]).to eq("CSVファイルの１行目は「name」にしてください。")
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "CSVデータのフォーマットが不正な場合" do
        post :import, params: { file: malform_file }
        expect(flash.now[:error]).to include("CSVファイルの形式が正しくありませんでした：")
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
