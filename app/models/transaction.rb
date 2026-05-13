class Transaction < ApplicationRecord
  belongs_to :user

  validates :title, :description, :status, :source, presence: true
  validates :points, numericality: { only_integer: true }

  scope :recent, -> { order(created_at: :desc) }
end
