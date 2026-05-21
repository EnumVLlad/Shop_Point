require "rails_helper"

RSpec.describe Loyalty::ExpirePoints do
  describe ".call" do
    it "expires earned bonuses older than 30 days and creates a compensating transaction" do
      user = create(:user, points_balance: 100, tier_points: 100)
      old_earning = create(:transaction, user:, points: 60, source: "purchase", created_at: 45.days.ago)

      result = described_class.call

      expect(result).to be_success
      expect(result.expired_users).to eq(1)
      expect(user.reload.points_balance).to eq(40)
      expect(user.tier_points).to eq(100)
      expect(old_earning.reload.expired_at).to be_present

      compensation = user.transactions.where(source: "expiration").last
      expect(compensation).to have_attributes(points: -60, status: "Expired")
    end

    it "does not touch earnings younger than 30 days" do
      user = create(:user, points_balance: 50, tier_points: 50)
      fresh = create(:transaction, user:, points: 50, source: "purchase", created_at: 10.days.ago)

      described_class.call

      expect(user.reload.points_balance).to eq(50)
      expect(fresh.reload.expired_at).to be_nil
      expect(user.transactions.where(source: "expiration")).to be_empty
    end

    it "does not double-expire already expired transactions on a second run" do
      user = create(:user, points_balance: 100, tier_points: 100)
      create(:transaction, user:, points: 60, source: "purchase", created_at: 45.days.ago)

      described_class.call
      balance_after_first = user.reload.points_balance

      described_class.call

      expect(user.reload.points_balance).to eq(balance_after_first)
      expect(user.transactions.where(source: "expiration").count).to eq(1)
    end

    it "clamps points_balance to zero instead of going negative" do
      user = create(:user, points_balance: 20, tier_points: 100)
      create(:transaction, user:, points: 100, source: "purchase", created_at: 45.days.ago)

      described_class.call

      expect(user.reload.points_balance).to eq(0)
    end

    it "only expires earning transactions, ignoring expirations and redemptions" do
      user = create(:user, points_balance: 100, tier_points: 100)
      create(:transaction, user:, points: -30, source: "expiration", status: "Expired", created_at: 45.days.ago)

      described_class.call

      expect(user.reload.points_balance).to eq(100)
      expect(user.transactions.where(source: "expiration").count).to eq(1)
    end

    it "aggregates multiple expirable earnings per user into one compensating transaction" do
      user = create(:user, points_balance: 200, tier_points: 200)
      create(:transaction, user:, points: 50, source: "purchase", created_at: 40.days.ago, order_number: "OLD-1")
      create(:transaction, user:, points: 70, source: "purchase", created_at: 60.days.ago, order_number: "OLD-2")

      described_class.call

      expect(user.reload.points_balance).to eq(80)
      compensations = user.transactions.where(source: "expiration")
      expect(compensations.count).to eq(1)
      expect(compensations.sum(:points)).to eq(-120)
    end
  end
end
