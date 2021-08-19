# frozen_string_literal: true

class GoalSerializer < ActiveModel::Serializer
  attributes :id, :name, :is_completed, :goal_type, :note, :observed_errors,
             :result, :user_id, :plan_of_care

  def observed_errors
    object.observed_errors
  end

  def result
    object.pronoun_result
  end
end
