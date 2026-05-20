module Purchases
  class Apply
    include Interactor

    def call
      ActiveRecord::Base.transaction do
        context.user.update!(
          points_balance: context.user.points_balance - context.redeemed_points.to_i + context.points,
          tier_points: context.user.tier_points + context.points
        )
        context.transaction = context.user.transactions.create!(transaction_attributes)
      end
    rescue ActiveRecord::RecordInvalid => e
      context.fail!(error: e.record.errors.full_messages.to_sentence)
    end

    private

    def transaction_attributes
      {
        title: "Order ##{context.order_number}",
        description: context.description.presence || "Purchase webhook processed",
        points: context.points,
        status: "Completed",
        source: "purchase",
        order_number: context.order_number,
        purchase_amount: context.amount,
        eligible_amount: context.eligible_amount,
        redeemed_points: context.redeemed_points.to_i
      }
    end
  end
end
