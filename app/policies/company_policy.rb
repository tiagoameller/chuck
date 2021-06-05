class CompanyPolicy < ApplicationPolicy
  def index?
    user.super_admin?
  end

  def show?
    user.at_least_admin?
  end

  def edit?
    user.at_least_admin?
  end

  def update?
    user.at_least_admin?
  end

  def destroy?
    user.super_admin?
  end
end
