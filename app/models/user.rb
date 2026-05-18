class User < ApplicationRecord
  enum :role, { customer: 0, admin: 1 }

  belongs_to :tier, optional: true
  has_many :transactions, dependent: :destroy
  before_save :assign_tier_from_points, if: :will_save_change_to_tier_points?

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def assign_tier_from_points
    self.tier = Tier.where("min_points <= ?", tier_points).order(min_points: :desc).first
  end
end
