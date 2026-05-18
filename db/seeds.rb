bronze = Tier.find_or_initialize_by(name: "Bronze")
bronze.update!(min_points: 0, bonus_rate: 10)

silver = Tier.find_or_initialize_by(name: "Silver")
silver.update!(min_points: 1_000, bonus_rate: 15)

gold = Tier.find_or_initialize_by(name: "Gold")
gold.update!(min_points: 2_000, bonus_rate: 20)

platinum = Tier.find_or_initialize_by(name: "Platinum")
platinum.update!(min_points: 3_000, bonus_rate: 25)

admin = User.find_or_initialize_by(email: ENV.fetch("ADMIN_EMAIL", "vladpilipenko640@gmail.com"))
admin.password = ENV.fetch("ADMIN_PASSWORD", "Pilipenko1234") if admin.new_record?
admin.password_confirmation = ENV.fetch("ADMIN_PASSWORD", "Pilipenko1234") if admin.new_record?
admin.role = :admin
admin.points_balance = 10_000
admin.tier_points = 10_000
admin.save!

customer = User.find_or_initialize_by(email: "alex.morgan@example.com")
customer.password = "password123" if customer.new_record?
customer.password_confirmation = "password123" if customer.new_record?
customer.role = :customer
customer.points_balance = 12_480
customer.tier_points = 12_480
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
