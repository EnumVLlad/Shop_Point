require "rails_helper"

RSpec.describe "ActiveAdmin access", type: :request do
  it "redirects unauthenticated visitors to the sign in page" do
    get "/active_admin"

    expect(response).to redirect_to(new_user_session_path)
  end

  it "redirects signed-in customers away from the admin panel" do
    sign_in create(:user, role: :customer)

    get "/active_admin"

    expect(response).to redirect_to(dashboard_path)
  end

  it "lets admins reach the dashboard, users index and transactions index" do
    sign_in create(:user, role: :admin)

    get "/active_admin"
    expect(response).to have_http_status(:ok)

    get "/active_admin/users"
    expect(response).to have_http_status(:ok)

    get "/active_admin/transactions"
    expect(response).to have_http_status(:ok)

    get "/active_admin/tiers"
    expect(response).to have_http_status(:ok)
  end
end
