# frozen_string_literal: true

class Goals::UpdateIntr < ApplicationInteraction
  object :goal

  string :name, :goal_type
  hash :note, default: nil, strip: false

  def execute
    errors.merge! goal.errors unless goal.update(inputs.except(:goal))
    goal
  end
end
