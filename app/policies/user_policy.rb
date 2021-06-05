class UserPolicy < ApplicationPolicy
  def set_company?
    user.super_admin?
  end

  def set_active?
    user.at_least_admin?
  end

  def super_admin? # rubocop:disable Rails/Delegate
    user.super_admin?
  end

  def index?
    user.at_least_admin?
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
    user.at_least_admin?
  end

  def pricing?
    # always false in this project
    false
  end

  def edit_role?
    user.at_least_admin?
  end

  def edit_passwords?
    user.at_least_admin?
  end
end
