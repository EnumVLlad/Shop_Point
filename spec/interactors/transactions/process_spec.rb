require "rails_helper"

RSpec.describe Transactions::Process do
  describe ".call" do
    it "creates a purchase transaction and updates the user balance" do
      tier = create(:tier, bonus_rate: 15)
      user = create(:user, tier:, points_balance: 100)

      result = described_class.call(user:, amount: 120.75, order_number: "LC-2001")

      expect(result).to be_success
      expect(result.points).to eq(18)
      expect(user.reload.points_balance).to eq(118)
      expect(user.tier_points).to eq(118)
      expect(result.transaction).to have_attributes(
        user:,
        title: "Order #LC-2001",
        description: "Transaction webhook processed",
        points: 18,
        status: "Completed",
        source: "purchase",
        order_number: "LC-2001"
      )
    end

    it "uses a custom transaction description when provided" do
      user = create(:user, tier: create(:tier, bonus_rate: 10))

      result = described_class.call(user:, amount: 50, order_number: "LC-2002", description: "Shoes purchase")

      expect(result).to be_success
      expect(result.transaction.description).to eq("Shoes purchase")
    end

    it "calculates points using the current tier cashback rate" do
      user = create(:user, tier: create(:tier, bonus_rate: 25))

      result = described_class.call(user:, amount: 99.99, order_number: "LC-2003")

      expect(result).to be_success
      expect(result.cashback_rate).to eq(25)
      expect(result.points).to eq(24)
    end

    it "falls back to a tier selected by points balance when the user has no assigned tier" do
      create(:tier, name: "Bronze", min_points: 0, bonus_rate: 10)
      create(:tier, name: "Gold", min_points: 2_000, bonus_rate: 20)
      user = create(:user, tier: nil, points_balance: 2_500)

      result = described_class.call(user:, amount: 100, order_number: "LC-2004")

      expect(result).to be_success
      expect(result.cashback_rate).to eq(20)
      expect(result.points).to eq(20)
    end

    it "calculates cashback only from the amount paid after redeemed points" do
      tier = create(:tier, name: "Gold", min_points: 2_000, bonus_rate: 20)
      user = create(:user, tier:, points_balance: 1_000, tier_points: 2_000)

      result = described_class.call(user:, amount: 1_000, redeemed_points: 300, order_number: "LC-2007")

      expect(result).to be_success
      expect(result.eligible_amount).to eq(700)
      expect(result.points).to eq(140)
      expect(user.reload.points_balance).to eq(840)
      expect(user.tier_points).to eq(2_140)
      expect(user.tier).to eq(tier)
    end

    it "does not reduce tier points when redeemed points are used" do
      tier = create(:tier, name: "Gold", min_points: 2_000, bonus_rate: 20)
      user = create(:user, tier:, points_balance: 500, tier_points: 2_000)

      result = described_class.call(user:, amount: 500, redeemed_points: 500, order_number: "LC-2008")

      expect(result).to be_success
      expect(result.points).to eq(0)
      expect(user.reload.points_balance).to eq(0)
      expect(user.tier_points).to eq(2_000)
      expect(user.tier).to eq(tier)
    end

    it "fails when required transaction data is missing" do
      user = create(:user)

      result = described_class.call(user:, amount: 100)

      expect(result).to be_failure
      expect(result.error).to eq("Missing transaction data")
      expect(user.reload.points_balance).to eq(0)
      expect(Transaction.count).to eq(0)
    end

    it "fails when the amount is not greater than zero" do
      user = create(:user)

      result = described_class.call(user:, amount: 0, order_number: "LC-2005")

      expect(result).to be_failure
      expect(result.error).to eq("Amount must be greater than zero")
      expect(user.reload.points_balance).to eq(0)
      expect(Transaction.count).to eq(0)
    end

    it "fails when redeemed points exceed the available balance" do
      user = create(:user, points_balance: 100)

      result = described_class.call(user:, amount: 500, redeemed_points: 101, order_number: "LC-2009")

      expect(result).to be_failure
      expect(result.error).to eq("Redeemed points cannot exceed available balance")
      expect(user.reload.points_balance).to eq(100)
      expect(Transaction.count).to eq(0)
    end

    it "fails when redeemed points exceed the purchase amount" do
      user = create(:user, points_balance: 200)

      result = described_class.call(user:, amount: 100, redeemed_points: 101, order_number: "LC-2010")

      expect(result).to be_failure
      expect(result.error).to eq("Redeemed points cannot exceed purchase amount")
      expect(user.reload.points_balance).to eq(200)
      expect(Transaction.count).to eq(0)
    end

    it "fails when the user is not persisted" do
      user = build(:user)

      result = described_class.call(user:, amount: 100, order_number: "LC-2006")

      expect(result).to be_failure
      expect(result.error).to eq("User must exist")
      expect(Transaction.count).to eq(0)
    end
  end
end
