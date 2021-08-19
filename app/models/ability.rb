# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.patient?
      can :index, User
      can [:index, :show, :create, :update, :destroy], PlanOfCare
      can :show, Goal
      can :create, PatientHistory
    end

    if user.therapists?
      can :index, User
      can [:index, :show], PlanOfCare
      can [:index, :show, :create, :update, :destroy], Goal
    end
  end
end
