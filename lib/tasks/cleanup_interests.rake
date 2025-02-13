namespace :interests do
  desc "3時間以上経過した interest を削除"
  task cleanup: :environment do
    expired_count = Interest.where("created_at <= ?", 1.minute.ago).delete_all
    puts "#{expired_count} 件の古い interest を削除しました。"
  end
end
