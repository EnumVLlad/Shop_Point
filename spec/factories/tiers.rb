FactoryBot.define do
  factory :tier do
    sequence(:name) { |number| "Tier #{number}" }
    min_points { 0 }
    bonus_rate { 1 }
  end
end
