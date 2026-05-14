module Admin
  class BaseController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_admin!

    private

    def authorize_admin!
      redirect_to dashboard_path, alert: t("admin.access_only") unless current_user.admin?
    end
  end
end
