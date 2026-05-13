bronze = Tier.find_or_create_by!(name: "Bronze") do |tier|
  tier.min_points = 0
  tier.bonus_rate = 1
end

silver = Tier.find_or_create_by!(name: "Silver") do |tier|
  tier.min_points = 5_000
  tier.bonus_rate = 3
end

gold = Tier.find_or_create_by!(name: "Gold") do |tier|
  tier.min_points = 10_000
  tier.bonus_rate = 7
end

Tier.find_or_create_by!(name: "Platinum") do |tier|
  tier.min_points = 15_000
  tier.bonus_rate = 10
end

admin = User.find_or_initialize_by(email: ENV.fetch("ADMIN_EMAIL", "vladpilipenko640@gmail.com"))
admin.password = ENV.fetch("ADMIN_PASSWORD", "Pilipenko1234") if admin.new_record?
admin.password_confirmation = ENV.fetch("ADMIN_PASSWORD", "Pilipenko1234") if admin.new_record?
admin.role = :admin
admin.points_balance = 10_000
admin.save!

customer = User.find_or_initialize_by(email: "alex.morgan@example.com")
customer.password = "password123" if customer.new_record?
customer.password_confirmation = "password123" if customer.new_record?
customer.role = :customer
customer.points_balance = 12_480
customer.save!

[
  { title: "Order #LC-1048", description: "Purchase webhook processed", points: 420, status: "Completed", source: "purchase", order_number: "LC-1048", created_at: 2.minutes.ago },
  { title: "Tier bonus", description: "Gold loyalty multiplier", points: 95, status: "Applied", source: "tier_bonus", order_number: nil, created_at: 18.minutes.ago },
  { title: "Order #LC-1047", description: "Fashion category purchase", points: 310, status: "Completed", source: "purchase", order_number: "LC-1047", created_at: 1.hour.ago },
  { title: "Manual adjustment", description: "Support compensation", points: 150, status: "Reviewed", source: "manual", order_number: nil, created_at: 1.day.ago },
  { title: "Order #LC-1046", description: "Electronics category purchase", points: 580, status: "Completed", source: "purchase", order_number: "LC-1046", created_at: 2.days.ago },
  { title: "Referral reward", description: "Friend joined LoyaltyCore", points: 250, status: "Applied", source: "referral", order_number: nil, created_at: 3.days.ago },
  { title: "Order #LC-1045", description: "Home goods purchase webhook", points: 205, status: "Completed", source: "purchase", order_number: "LC-1045", created_at: 5.days.ago }
].each do |attributes|
  transaction = customer.transactions.find_or_initialize_by(title: attributes[:title])
  transaction.update!(attributes)
end
