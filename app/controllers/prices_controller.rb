class PricesController < ApplicationController
  # controllersのconcernsにあるframeable.rbをインクルード
  include Frameable
  # 本番環境で指定したアクションへのリクエストがTurboFrameでない場合は、トップページにリダイレクトされる。
  before_action :ensure_turbo_frame_response, only: %w[select_city confirm], if: :production_environment?
  before_action :authenticate, only: [ :new ]

  # ActionController::InvalidAuthenticityTokenのエラー回避
  protect_from_forgery

  def index
    # 初期化。引数はなくてもOK。
    @search_form = SearchPricesForm.new(search_params)
    # @search_formを元にsearch_prices_formのメソッドで絞り込み
    @prices = @search_form.search(page: params[:page])
    @cities = City.all
  end

  def new
  end

  # bulk insertによるcreate
  def create
    cities = City.all
    items = Item.all
    timestamp = Time.current

    new_prices = []

    cities.each do |city|
      items.each do |item|
        next if Price.exists?(city_id: city.id, item_id: item.id)

        new_prices << {
          city_id: city.id,
          item_id: item.id,
          price_percentage: rand(90..110),
          trend: [ true, false ].sample,
          created_at: timestamp,
          updated_at: timestamp
        }
      end
    end

    if new_prices.present?
      # bulk insert
      Price.insert_all(new_prices)
      redirect_to prices_path, success: "新しい価格データを追加しました。"
    else
      redirect_to new_price_path, alert: "追加できる価格データがありません。"
    end
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
      redirect_to root_path, status: :see_other, alert: "更新操作途中で一定時間経過したためセッションが切れました"
    end
  end

  # 相場情報を更新する商品を選択
  def add_price_field
    # セッションが切れていないか確認
    if session[:added_item_ids].nil?
      flash.alert = "更新途中で一定時間(5分)経過したためセッションが切れました"
      redirect_to edit_by_city_prices_path, status: :see_other
      return
    end

    # formから商品名が渡されているか判定
    if params[:item_name].blank?
      flash.now.notice = "商品名を入力してください"
      return
    end

    item_id = Item.where(name: params[:item_name]).pick(:id)
    city_id = params[:city_id]

    if item_id
      # 更新対象に追加しようとしている商品が既ににセッションにないか判定
      if session[:added_item_ids].include?(item_id)
        flash.now.alert = "この商品はすでに追加されています"
        return
      end

      # 追加されている商品を数えて５つまでに制限する
      if session[:added_item_ids].length >= 5
        flash.now.alert = "一度の更新で5つまでしか追加できません"
        return
      end

      # 更新対象として追加する商品をセッションに登録する
      session[:added_item_ids] << item_id

      @price = Price.find_by(city_id: city_id, item_id: item_id)
    else
      flash.now.alert = "指定した名前の商品は登録されていません"
    end
  end

  def confirm
    # pricesはネスト構造の情報として渡されているのでPricesモデルのインスタンスとして扱うことはできない
    if params[:prices].blank?
      flash.now.alert = "商品が選択されていません"
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update("flash", partial: "shared/flash_message"),
            turbo_stream.update("modal", "")
          ]
        end
      end
      return
    end
    @city_id = params[:city_id]
    @prices = params[:prices]
  end

  # 更新の競合に関してはアプリの用途的に気にしない
  def update_by_city
    if request.get? || request.head?
      redirect_to edit_by_city_prices_path
      return
    end

    errors = []

    ActiveRecord::Base.transaction do
      params[:prices].each do |id, attributes|
        price = Price.find(id)
        new_price_percentage = attributes[:price_percentage].to_i
        new_trend = attributes[:trend] == "true"

        # 関連するInterestがあるなら削除
        if price.interests.present?
          price.interests.destroy_all
        end

        if price.price_percentage != new_price_percentage || price.trend != new_trend
          unless price.update(price_percentage: new_price_percentage, trend: new_trend)
            errors << "#{price.item.name} - #{price.errors.full_messages.join(', ')}"
          end
        else
          price.touch
        end
      end

      raise ActiveRecord::Rollback if errors.any?
    end

    if errors.any?
      flash.now[:danger] = "更新に失敗しました:<br>#{errors.join('<br>')}"
      session[:city_id] = params[:city_id]
      @city = City.find(session[:city_id])
      session[:added_item_ids] = []
      render :edit_by_city, status: :unprocessable_entity
    else
      flash[:success] = "ありがとうございます！更新が完了しました"
      redirect_to root_path
    end
  end


  private

  # :search_prices_formはasで指定しない限り自動的にオブジェクトのクラス名となる
  def search_params
    params.fetch(:search_prices_form, {}).permit(:city_id, :item_name, :min_price, :max_price, :trend, :sort_key)
  end

  # def price_params
  #   params.require(:price).permit(:price_percentage, :trend)
  # end
end
