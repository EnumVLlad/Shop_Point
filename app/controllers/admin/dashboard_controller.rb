module Admin
  class DashboardController < BaseController
    def index
      @admin_stats = [
        { label: "Registered users", value: User.count },
        { label: "Admins", value: User.admin.count },
        { label: "Customers", value: User.customer.count },
        { label: "Transactions", value: Transaction.count }
      ]
    end
  end
end
