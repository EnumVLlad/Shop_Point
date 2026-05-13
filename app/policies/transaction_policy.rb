class TransactionPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      return scope.all if user.admin?

      scope.where(user: user)
    end
  end
end
