require "swagger_helper"

RSpec.describe "API V1 Transactions", type: :request do
  path "/api/v1/transactions" do
    post "Processes a purchase transaction and applies loyalty points" do
      tags "Transactions"
      consumes "application/json"
      produces "application/json"

      parameter name: :transaction, in: :body, schema: {
        type: :object,
        properties: {
          transaction: {
            type: :object,
            properties: {
              user_id: { type: :integer },
              amount: { type: :number, format: :float },
              redeemed_points: { type: :integer },
              order_number: { type: :string },
              description: { type: :string }
            },
            required: %w[user_id amount order_number]
          }
        },
        required: %w[transaction]
      }

      response "201", "transaction processed" do
        let(:tier) { create(:tier, bonus_rate: 10) }
        let(:user) { create(:user, tier:, points_balance: 50, tier_points: 100) }
        let(:transaction) do
          {
            transaction: {
              user_id: user.id,
              amount: 100,
              redeemed_points: 10,
              order_number: "LC-3001",
              description: "API purchase"
            }
          }
        end

        schema type: :object,
               properties: {
                 transaction: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     order_number: { type: :string },
                     purchase_amount: { type: :string },
                     eligible_amount: { type: :string },
                     redeemed_points: { type: :integer },
                     points: { type: :integer },
                     status: { type: :string }
                   },
                   required: %w[id order_number purchase_amount eligible_amount redeemed_points points status]
                 },
                 user: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     points_balance: { type: :integer },
                     tier_points: { type: :integer }
                   },
                   required: %w[id points_balance tier_points]
                 }
               },
               required: %w[transaction user]

        run_test! do |response|
          body = JSON.parse(response.body)

          expect(body.dig("transaction", "order_number")).to eq("LC-3001")
          expect(body.dig("transaction", "points")).to eq(9)
          expect(body.dig("user", "points_balance")).to eq(49)
          expect(body.dig("user", "tier_points")).to eq(109)
        end
      end

      response "422", "transaction validation failed" do
        let(:user) { create(:user, points_balance: 5) }
        let(:transaction) do
          {
            transaction: {
              user_id: user.id,
              amount: 100,
              redeemed_points: 10,
              order_number: "LC-3002"
            }
          }
        end

        schema "$ref" => "#/components/schemas/error"

        run_test! do |response|
          body = JSON.parse(response.body)

          expect(body["error"]).to eq("Redeemed points cannot exceed available balance")
        end
      end
    end
  end
end
