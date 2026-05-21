class ApplicationController < ActionController::Base
  include Pundit::Authorization
  before_action :set_locale

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  def after_sign_in_path_for(_resource)
    dashboard_path
  end

  def after_sign_up_path_for(_resource)
    dashboard_path
  end

  def authorize_active_admin!
    redirect_to dashboard_path, alert: t("admin.access_only") unless current_user&.admin?
  end

  private

  def set_locale
    requested_locale = params[:locale].presence_in(%w[en uk])
    session[:locale] = requested_locale if requested_locale
    cookies.permanent[:locale] = requested_locale if requested_locale
    I18n.locale = requested_locale || session[:locale] || cookies[:locale] || I18n.default_locale
  end
end
