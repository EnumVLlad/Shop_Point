module Admin
  class TransactionsController < BaseController
    def index
      @transactions = Transaction.includes(user: :tier).recent
    end
  end
end
