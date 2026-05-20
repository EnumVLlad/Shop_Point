module Transactions
  class Process
    include Interactor::Organizer

    organize Transactions::Validate, Transactions::CalculatePoints, Transactions::Apply
  end
end
