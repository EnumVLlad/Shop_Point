require "rails_helper"

RSpec.describe ExpirePointsJob do
  it "delegates to the Loyalty::ExpirePoints interactor" do
    expect(Loyalty::ExpirePoints).to receive(:call)

    described_class.new.perform
  end
end
