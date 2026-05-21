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

  def dashboard_snapshot
    current_tier = tier || Tier.order(:min_points).first
    next_tier_record = Tier.where("min_points > ?", tier_points).order(:min_points).first
    next_tier_points = next_tier_record&.min_points || tier_points
    points_to_next_tier = [next_tier_points - tier_points, 0].max
    tier_progress = next_tier_record ? [(tier_points.to_f / next_tier_record.min_points * 100).round, 100].min : 100

    {
      customer: self,
      tier: current_tier,
      next_tier: next_tier_record,
      points_to_next_tier: points_to_next_tier,
      tier_progress: tier_progress
    }
  end
end
