class Transaction < ApplicationRecord
  belongs_to :user

  validates :title, :description, :status, :source, presence: true
  validates :points, numericality: { only_integer: true }

  scope :recent, -> { order(created_at: :desc) }

  def self.ransackable_attributes(_auth_object = nil)
    %w[id user_id title description status source order_number points
       purchase_amount eligible_amount redeemed_points expired_at created_at updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[user]
  end
end
