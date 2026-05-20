require "rails_helper"

RSpec.describe ApplicationInteractor do
  before do
    stub_const("ValidatedInteractor", Class.new(described_class) do
      validates :amount, presence: true
      validates :amount, numericality: { greater_than: 0 }, allow_blank: true

      def call
        context.processed = true
      end
    end)
  end

  describe ".call" do
    it "runs the interactor when context validations pass" do
      result = ValidatedInteractor.call(amount: 100)

      expect(result).to be_success
      expect(result.processed).to be(true)
    end

    it "fails before call when context validations fail" do
      result = ValidatedInteractor.call(amount: 0)

      expect(result).to be_failure
      expect(result.processed).to be_nil
      expect(result.error).to eq("Amount must be greater than 0")
      expect(result.errors).to eq(amount: ["must be greater than 0"])
    end

    it "reads validation attributes from the interactor context" do
      result = ValidatedInteractor.call

      expect(result).to be_failure
      expect(result.error).to eq("Amount can't be blank")
      expect(result.errors).to eq(amount: ["can't be blank"])
    end
  end
end
