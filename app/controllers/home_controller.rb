class HomeController < ApplicationController
  def index
    redirect_to dashboard_path and return if user_signed_in?

    @public_deals = [
      { title: t("home.deals.weekend_discounts.title"), description: t("home.deals.weekend_discounts.description") },
      { title: t("home.deals.loyalty_rewards.title"), description: t("home.deals.loyalty_rewards.description") },
      { title: t("home.deals.partner_campaigns.title"), description: t("home.deals.partner_campaigns.description") }
    ]
  end
end
