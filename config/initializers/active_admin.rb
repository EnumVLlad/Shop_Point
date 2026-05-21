ActiveAdmin.setup do |config|
  config.site_title = "Shop Point Admin"
  config.default_namespace = :active_admin
  config.authentication_method = :authenticate_user!
  config.current_user_method = :current_user
  config.logout_link_path = :destroy_user_session_path
  config.logout_link_method = :delete
  config.before_action :authorize_active_admin!

  config.comments = false
end
