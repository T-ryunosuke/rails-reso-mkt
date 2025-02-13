class InterestsController < ApplicationController
  before_action :set_price, only: [ :create ]

  # 「気になる」を押したとき
  def create
    @price.with_lock do
      @interest = @price.interests.create!
    end
    render turbo_stream: turbo_stream.replace(
      "interested_#{@price.id}",
      partial: "interests/interest",
      locals: { price: @price }
    )
  end

  private

  def set_price
    @price = Price.find(params[:price_id])
  end
end
