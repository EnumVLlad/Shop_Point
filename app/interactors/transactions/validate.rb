module Transactions
  class Validate
    include Interactor

    REQUIRED_ATTRIBUTES = %i[user amount order_number].freeze

    def call
      context.fail!(error: "Missing transaction data") if missing_attributes?
      context.fail!(error: "User must exist") unless context.user.is_a?(User) && context.user.persisted?
      context.fail!(error: "Amount must be greater than zero") unless amount.positive?
      context.fail!(error: "Redeemed points cannot be negative") if redeemed_points.negative?
      context.fail!(error: "Redeemed points cannot exceed available balance") if redeemed_points > context.user.points_balance
      context.fail!(error: "Redeemed points cannot exceed purchase amount") if redeemed_points > amount
      context.redeemed_points = redeemed_points
    end

    private

    def missing_attributes?
      REQUIRED_ATTRIBUTES.any? { |attribute| context.public_send(attribute).blank? }
    end

    def amount
      BigDecimal(context.amount.to_s)
    rescue ArgumentError
      BigDecimal("0")
    end

    def redeemed_points
      BigDecimal(context.redeemed_points.to_s.presence || "0")
    rescue ArgumentError
      BigDecimal("-1")
    end
  end
end
