class SearchPricesForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :city_id, :integer, default: 1
  attribute :item_name, :string
  attribute :item_id, :integer
  attribute :min_price, :integer
  attribute :max_price, :integer
  attribute :trend, :string, default: "all"
  attribute :sort_order, :boolean

  def search
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

    if sort_order
      scope = scope.order(updated_at: :desc)
    end

    scope
  end
end
