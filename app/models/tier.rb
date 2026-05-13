class Tier < ApplicationRecord
  has_many :users, dependent: :nullify

  validates :name, presence: true, uniqueness: true
  validates :min_points, numericality: { greater_than_or_equal_to: 0 }
  validates :bonus_rate, numericality: { greater_than_or_equal_to: 0 }
end
