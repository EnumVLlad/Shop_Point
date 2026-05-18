module Purchases
  class CalculatePoints
    include Interactor

    def call
      context.eligible_amount = amount - context.redeemed_points
      context.cashback_rate = tier&.bonus_rate || 10
      context.points = (context.eligible_amount * context.cashback_rate / 100).floor
    end

    private

    def amount
      BigDecimal(context.amount.to_s)
    end

    def tier
      context.user.tier || Tier.where("min_points <= ?", context.user.tier_points).order(min_points: :desc).first
    end
  end
end
