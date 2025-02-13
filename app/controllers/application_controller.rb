class ApplicationController < ActionController::Base
  # chromeの検証ツールでデバイスモード使用中に画面遷移をすると406エラーページが表示されるのは以下の"allow_browser versions: :modern"が原因
  allow_browser versions: :modern
  add_flash_types :success, :danger
  before_action :cleanup_old_interests, if: :should_cleanup?

  private

  def should_cleanup?
    # 最後のクリーンアップから6時間以上経過している場合のみ実行
    last_cleanup = Rails.cache.read("last_cleanup_time")
    last_cleanup.nil? || last_cleanup < 3.hour.ago
  end

  def cleanup_old_interests
    # 3時間以上前のInterestを削除
    Interest.where("created_at < ?", 3.hour.ago).delete_all

    # 最後のクリーンアップ時刻を更新
    Rails.cache.write("last_cleanup_time", Time.current)
  end
end
