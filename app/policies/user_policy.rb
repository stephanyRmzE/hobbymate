class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def edit?
    true
  end

  def update?
    true
  end

  def destroy?
    true
  end

  def next_match?
    true
  end

  def show?
    true
  end
end
