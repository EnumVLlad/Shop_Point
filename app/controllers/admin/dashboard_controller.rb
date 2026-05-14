module Admin
  class DashboardController < BaseController
    def index
      @admin_stats = [
        { label: t("admin.stats.registered_users"), value: User.count },
        { label: t("admin.stats.admins"), value: User.admin.count },
        { label: t("admin.stats.customers"), value: User.customer.count },
        { label: t("admin.stats.transactions"), value: Transaction.count }
      ]
    end
  end
end
