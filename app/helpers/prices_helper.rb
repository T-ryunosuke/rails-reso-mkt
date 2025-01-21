module PricesHelper
  def time_ago_in_detailed_words(from_time)
    time_diff = Time.current - from_time
    hours = (time_diff / 1.hour).to_i
    minutes = ((time_diff % 1.hour) / 1.minute).to_i

    if hours >= 6
      "6時間以上前"
    elsif hours > 0
      "#{hours}時間#{minutes}分前"
    else
      "#{minutes}分前"
    end
  end
end
