module Admin
  class UsersController < BaseController
    def index
      @title = t("admin.users.all_title")
      @users = User.includes(:tier).order(created_at: :desc)
    end

    def admins
      @title = t("admin.users.admins_title")
      @users = User.admin.includes(:tier).order(created_at: :desc)
      render :index
    end

    def customers
      @title = t("admin.users.customers_title")
      @users = User.customer.includes(:tier).order(created_at: :desc)
      render :index
    end

    def transactions
      @user = User.find(params[:id])
      @transactions = @user.transactions.recent
      @return_to = params[:return_to].presence || admin_users_path
    end
  end
end
