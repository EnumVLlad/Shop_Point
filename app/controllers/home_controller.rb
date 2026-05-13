class HomeController < ApplicationController
  def index
    redirect_to dashboard_path and return if user_signed_in?

    @public_deals = [
      { title: "Weekend discounts", description: "Discover limited-time offers from connected e-commerce stores." },
      { title: "Loyalty rewards", description: "Create an account to collect points and unlock personalized bonuses." },
      { title: "Partner campaigns", description: "Follow new campaigns and special offers from marketplace partners." }
    ]
  end
end
