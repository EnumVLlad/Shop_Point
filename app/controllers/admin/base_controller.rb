module Admin
  class BaseController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_admin!

    private

    def authorize_admin!
      redirect_to dashboard_path, alert: "Admin access only." unless current_user.admin?
    end
  end
end
