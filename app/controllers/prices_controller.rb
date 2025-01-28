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
end
