module Purchases
  class Process
    include Interactor::Organizer

    organize Purchases::Validate, Purchases::CalculatePoints, Purchases::Apply
  end
end
