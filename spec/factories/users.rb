FactoryBot.define do
  factory :user do
    sequence(:email) { |number| "user#{number}@example.com" }
    password { "password123" }
    password_confirmation { "password123" }
    points_balance { 0 }
    tier_points { points_balance }
    role { :customer }
    association :tier
  end
end
