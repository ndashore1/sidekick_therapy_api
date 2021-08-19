# frozen_string_literal: true

class V1::GoalsController < ApplicationController
  before_action :set_plan_of_care
  before_action :set_goal, only: %w[show update destroy]

  authorize_resource

  def index
    goals = @plan_of_care.goals

    render json: goals, each_serializer: GoalSerializer
  end

  def show
    render json: @goal, serializer: GoalSerializer
  end

  def create
    outcome = Goals::CreateIntr.run(goal_params.merge(plan_of_care: @plan_of_care, user: @current_user))
    return render_success_response(I18n.t("created", entity: "Goal"), goal: outcome.result) if outcome.valid?

    render_error_response(outcome.errors.full_messages.to_sentence)
  end

  def update
    outcome = Goals::UpdateIntr.run(goal_params.merge(goal: @goal))
    return render_success_response(I18n.t("updated", entity: "Goal"), goal: outcome.result) if outcome.valid?

    render_error_response(outcome.errors.full_messages.to_sentence)
  end

  def destroy
    return render_success_response(I18n.t("destroyed", entity: "Goal")) if @goal.destroy

    render_error_response(@goal.errors.full_messages.to_sentence)
  end

  private
  def goal_params
    params.require(:goals).permit!
  end

  def set_plan_of_care
    @plan_of_care = PlanOfCare.find_by(id: params[:plan_of_care_id])

    render_error_response(I18n.t("error.not_found", entity: "Plan of Care")) if @plan_of_care.blank?
  end

  def set_goal
    @goal = Goal.find_by(id: params[:id])

    render_error_response(I18n.t("error.not_found", entity: "Goal")) if @goal.blank?
  end
end
