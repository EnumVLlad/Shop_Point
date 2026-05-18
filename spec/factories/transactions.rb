FactoryBot.define do
  factory :transaction do
    association :user
    title { "Order #LC-1000" }
    description { "Purchase webhook processed" }
    points { 100 }
    status { "Completed" }
    source { "purchase" }
    order_number { "LC-1000" }
  end
end
