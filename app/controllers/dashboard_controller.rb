class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @customer = current_user
    @tier = @customer.tier || Tier.order(:min_points).first
    @next_tier = Tier.where("min_points > ?", @customer.tier_points).order(:min_points).first
    @transactions = @customer.transactions.recent.limit(20)
    @next_tier_points = @next_tier&.min_points || @customer.tier_points
    @points_to_next_tier = [@next_tier_points - @customer.tier_points, 0].max
    @tier_progress = @next_tier ? [(@customer.tier_points.to_f / @next_tier.min_points * 100).round, 100].min : 100

    @stats = [
      { label: t("dashboard.stats.available_points"), value: helpers.number_with_delimiter(@customer.points_balance), trend: t("dashboard.stats.points_to_next", points: helpers.number_with_delimiter(@points_to_next_tier)) },
      { label: t("dashboard.stats.loyalty_tier"), value: @tier&.name || t("dashboard.starter"), trend: @next_tier ? t("dashboard.stats.next", tier: @next_tier.name) : t("dashboard.top_tier") },
      { label: t("dashboard.stats.purchases_tracked"), value: @transactions.count, trend: t("dashboard.stats.personal_history") },
      { label: t("dashboard.stats.bonus_rate"), value: "#{@tier&.bonus_rate || 1}%", trend: t("dashboard.stats.multiplier_active", tier: @tier&.name || t("dashboard.starter")) }
    ]
  end
end
