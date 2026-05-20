module Api
  module V1
    class TransactionsController < ActionController::API
      def create
        user = User.find_by(id: transaction_params[:user_id])

        result = Transactions::Process.call(
          user:,
          amount: transaction_params[:amount],
          redeemed_points: transaction_params[:redeemed_points],
          order_number: transaction_params[:order_number],
          description: transaction_params[:description]
        )

        if result.success?
          render json: success_payload(result), status: :created
        else
          render json: { error: result.error }, status: :unprocessable_entity
        end
      end

      private

      def transaction_params
        params.require(:transaction).permit(:user_id, :amount, :redeemed_points, :order_number, :description)
      end

      def success_payload(result)
        {
          transaction: {
            id: result.transaction.id,
            order_number: result.transaction.order_number,
            purchase_amount: result.transaction.purchase_amount.to_s,
            eligible_amount: result.transaction.eligible_amount.to_s,
            redeemed_points: result.transaction.redeemed_points,
            points: result.transaction.points,
            status: result.transaction.status
          },
          user: {
            id: result.user.id,
            points_balance: result.user.points_balance,
            tier_points: result.user.tier_points
          }
        }
      end
    end
  end
end
