# config/schedule.rb
require File.expand_path(File.dirname(__FILE__) + "/environment")

ENV.each { |k, v| env(k, v) }

# 環境を指定（デフォルトは development に）
rails_env = ENV["RAILS_ENV"] || "development"
set :environment, rails_env

# ログの出力先
set :output, "#{Rails.root}/log/cron.log"

every 1.minute do
  rake "interests:cleanup"
end
