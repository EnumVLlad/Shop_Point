module Loyalty
  class ExpirePoints
    include Interactor

    EXPIRATION_AGE = 30.days
    EARNING_SOURCE = "purchase".freeze

    def call
      expired_users = 0

      ActiveRecord::Base.transaction do
        expirable_scope.group_by(&:user_id).each do |user_id, transactions|
          total = transactions.sum(&:points)
          next if total.zero?

          user = User.lock.find(user_id)
          new_balance = [user.points_balance - total, 0].max

          user.update!(points_balance: new_balance)
          user.transactions.create!(expiration_attributes(total))
          Transaction.where(id: transactions.map(&:id)).update_all(expired_at: Time.current)

          expired_users += 1
        end
      end

      context.expired_users = expired_users
    end

    private

    def expirable_scope
      Transaction
        .where(source: EARNING_SOURCE, expired_at: nil)
        .where("points > 0")
        .where("created_at < ?", EXPIRATION_AGE.ago)
    end

    def expiration_attributes(total)
      {
        title: "Bonus expiration",
        description: "Bonuses older than 30 days expired",
        points: -total,
        status: "Expired",
        source: "expiration",
        purchase_amount: 0,
        eligible_amount: 0,
        redeemed_points: 0
      }
    end
  end
end
