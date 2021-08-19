# frozen_string_literal: true

class Goals::CreateIntr < ApplicationInteraction
  object :plan_of_care
  object :user

  string :name, :goal_type
  hash :note, default: nil, strip: false

  def execute
    goal = plan_of_care.goals.build(inputs)
    errors.merge!(goal.errors) unless goal.save
    goal
  end
end
