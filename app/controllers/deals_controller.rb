class DealsController < ApplicationController
  def index
    @deals = [
      { title: "Gold member bonus", description: "Extra 7% points on selected fashion purchases", badge: "Gold" },
      { title: "Weekend cashback", description: "Earn double points for weekend orders", badge: "Limited" },
      { title: "Partner store rewards", description: "Special loyalty rewards from connected shops", badge: "Partner" }
    ]
  end
end
