class PricesController < ApplicationController
  # controllersのconcernsにあるframeable.rbをインクルード
  include Frameable
  # 本番環境で指定したアクションへのリクエストがTurboFrameでない場合は、トップページにリダイレクトされる。
  before_action :ensure_turbo_frame_response, only: %w[select_city], if: :production_environment?

  # ActionController::InvalidAuthenticityTokenのエラー回避
  protect_from_forgery

  def index
    @prices = Price.includes(:city, :item).all
  end

  # どの都市の商品の情報を変更するか選択する
  def select_city
    @cities = City.all
  end

  # 選択した都市の編集画面
  def edit_by_city
    # postか判定（select_cityからなのかリロードなのかを判定）
    if request.post?
      session[:city_id] = params[:city_id]
    end

    # セッションが残っているか判定
    if session[:city_id].present?
      @city = City.find(session[:city_id])
      session[:added_item_ids] = []
    else
      redirect_to select_city_prices_path, alert: "都市が選択されていません"
    end
  end

  # 相場情報を更新する商品を選択
  def add_price_field
    # formから商品名が渡されているか判定
    if params[:item_name].blank?
      flash.now.notice = "商品名を入力してください"
      return
    end
    item_id = Item.where(name: params[:item_name]).pick(:id)
    city_id = params[:city_id]

    if item_id
      # セッションが切れていないか確認
      if session[:added_item_ids].present?
        # 更新対象に追加しようとしている商品が既ににセッションにないか判定
        if session[:added_item_ids].include?(item_id)
          flash.now.alert = "この商品はすでに追加されています"
          return
        else
          # 追加されている商品を数えて５つまでに制限する
          if session[:added_item_ids].length >= 5
            flash.now.alert = "一度の更新で5つまでしか追加できません"
            return
          else
            # 更新対象として追加する商品をセッションに登録する
            session[:added_item_ids] << item_id
          end
          flash.now.alert = "セッションが切れています"
          redirect_to edit_by_city_path
          return
        end
      end
      @price = Price.find_by(city_id: city_id, item_id: item_id)
    else
      flash.now.alert = "指定した名前の商品は登録されていません"
    end
  end
end
