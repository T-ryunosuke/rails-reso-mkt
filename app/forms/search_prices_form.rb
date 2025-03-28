class SearchPricesForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :city_id, :integer
  attribute :item_name, :string
  attribute :item_id, :integer
  attribute :min_price, :integer
  attribute :max_price, :integer
  attribute :trend, :string, default: "all"
  attribute :sort_key, :string, default: "newest"
  attribute :interested, :boolean, default: nil

  # バリデーション設定
  # validate :city_or_item_must_be_present
  validate :validate_sort_key

  def search(page: 1)
    if invalid?
      return Price.none
    end

    scope = Price.ransack(city_id_eq: city_id).result

    if item_name.present?
      scope = scope.joins(:item).merge(Item.ransack(name_cont: item_name).result)
    end

    # trendの検索条件
    if trend == "true"
      scope = scope.where(trend: true)
    elsif trend == "false"
      scope = scope.where(trend: false)
    end

    # 範囲検索を追加
    if min_price.present? && max_price.present?
      scope = scope.where("price_percentage BETWEEN ? AND ?", min_price, max_price)
    elsif min_price.present?
      scope = scope.where("price_percentage >= ?", min_price)
    elsif max_price.present?
      scope = scope.where("price_percentage <= ?", max_price)
    end

    # interestの検索条件
    if interested.present?
      scope = scope.joins(:interests).where(interests: { id: interested ? Interest.select(:id) : nil })
    end

    scope = apply_sorting(scope)

    scope.page(page).per(20)
  end

  private

  # カスタムバリデーション
  # def city_or_item_must_be_present
  #   if city_id.blank? && item_name.blank?
  #     errors.add(:base, :city_or_item_required)
  #   end
  # end

  def validate_sort_key
    unless %w[newest price_percentage item_name].include?(sort_key)
      errors.add(:base, :invalid_sort_key)
    end
  end

  # ソート処理
  def apply_sorting(scope)
    interests_subquery = Interest.where("interests.price_id = prices.id").select("1").limit(1)
    scope = scope.joins(:item).select("prices.*, EXISTS(#{interests_subquery.to_sql}) AS has_interests").order(Arel.sql("has_interests DESC"))

    case sort_key
    when "newest"
      scope.order(updated_at: :desc, "items.name": :asc)
    when "price_percentage"
      scope.order(price_percentage: :desc, "items.name": :asc)
    when "item_name"
      scope.order("items.name": :asc)
    end
  end
end
