class Tier < ApplicationRecord
  has_many :users, dependent: :nullify

  def self.ransackable_attributes(_auth_object = nil)
    %w[id name min_points bonus_rate created_at updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[users]
  end

  validates :name, presence: true, uniqueness: true
  validates :min_points, numericality: { greater_than_or_equal_to: 0 }
  validates :bonus_rate, numericality: { greater_than_or_equal_to: 0 }
end
