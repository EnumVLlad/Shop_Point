class DealsController < ApplicationController
  def index
    @deals = [
      { title: t("deals.items.gold.title"), description: t("deals.items.gold.description"), badge: t("deals.items.gold.badge") },
      { title: t("deals.items.weekend.title"), description: t("deals.items.weekend.description"), badge: t("deals.items.weekend.badge") },
      { title: t("deals.items.partner.title"), description: t("deals.items.partner.description"), badge: t("deals.items.partner.badge") }
    ]
  end
end
