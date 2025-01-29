module Frameable
  extend ActiveSupport::Concern

  private

  # turbo_frame_request?がfalseの場合、root_pathへリダイレクトさせる。
  def ensure_turbo_frame_response
    redirect_to root_path unless turbo_frame_request?
  end

  # Rails環境が本番かどうかを判定
  def production_environment?
    Rails.env.production?
  end
end
