module Admin
  class DashboardController < BaseController
    def index
      @admin_stats = [
        { label: t("admin.stats.registered_users"), value: User.count, path: admin_users_path },
        { label: t("admin.stats.admins"), value: User.admin.count, path: admin_admins_path },
        { label: t("admin.stats.customers"), value: User.customer.count, path: admin_customers_path },
        { label: t("admin.stats.transactions"), value: Transaction.count, path: admin_transactions_path }
      ]
    end
  end
end
