# frozen_string_literal: true

class V1::PlanOfCaresController < ApplicationController
  before_action :set_plan_of_care, only: %w[show update destroy]

  authorize_resource

  def index
    plan_of_cares = if @current_user.patient?
      current_user.plan_of_cares.includes(:patient_histories, :goals)
    else
      PlanOfCare.includes(:patient_histories, :goals)
        .where(patient_histories: { new_therapists_id: current_user.id })
    end

    render json: plan_of_cares, each_serializer: PlanOfCareSerializer
  end

  def show
    render json: @plan_of_care, serializer: PlanOfCareSerializer
  end

  def create
    outcome = PlanOfCares::CreateIntr.run(plan_of_care_params.merge(user: @current_user))
    return render_success_response(I18n.t("created", entity: "Plan of Care"),
                                   plan_of_care: outcome.result) if outcome.valid?

    render_error_response(outcome.errors.full_messages.to_sentence)
  end

  def update
    outcome = PlanOfCares::UpdateIntr.run(plan_of_care_params.merge(plan_of_care: @plan_of_care))
    return render_success_response(I18n.t("updated", entity: "Plan of Care"),
                                   plan_of_cares: outcome.result) if outcome.valid?

    render_error_response(outcome.errors.full_messages.to_sentence)
  end

  def destroy
    return render_success_response(I18n.t("destroyed", entity: "Plan of Care")) if @plan_of_care.destroy

    render_error_response(@plan_of_care.errors.full_messages.to_sentence)
  end

  private
  def plan_of_care_params
    params.require(:plan_of_care).permit(:title, :therapists_id)
  end

  def set_plan_of_care
    @plan_of_care = PlanOfCare.find_by(id: params[:id])

    render_error_response(I18n.t("error.not_found", entity: "Plan of Care")) if @plan_of_care.blank?
  end
end
