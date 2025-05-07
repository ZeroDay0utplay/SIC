# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.superadmin?
      can :manage, :all
    elsif user.admin?
      cannot :manage, :superadmin
    else
      can :read, :all
    end
  end
end
