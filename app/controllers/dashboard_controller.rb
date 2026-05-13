class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @customer = current_user
    @tier = @customer.tier || Tier.order(:min_points).first
    @next_tier = Tier.where("min_points > ?", @customer.points_balance).order(:min_points).first
    @transactions = policy_scope(Transaction).recent.limit(20)
    @next_tier_points = @next_tier&.min_points || @customer.points_balance
    @points_to_next_tier = [@next_tier_points - @customer.points_balance, 0].max
    @tier_progress = @next_tier ? [(@customer.points_balance.to_f / @next_tier.min_points * 100).round, 100].min : 100

    @stats = [
      { label: "Available points", value: helpers.number_with_delimiter(@customer.points_balance), trend: "#{helpers.number_with_delimiter(@points_to_next_tier)} points to next tier" },
      { label: "Loyalty tier", value: @tier&.name || "Starter", trend: @next_tier ? "Next: #{@next_tier.name}" : "Top tier reached" },
      { label: "Purchases tracked", value: @transactions.count, trend: "Visible through policy scope" },
      { label: "Bonus rate", value: "#{@tier&.bonus_rate || 1}%", trend: "#{@tier&.name || "Starter"} multiplier active" }
    ]
  end
end
