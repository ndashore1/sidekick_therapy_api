# frozen_string_literal: true

class V1::PatientHistoriesController < ApplicationController
  authorize_resource

  def create
    outcome = PatientHistories::CreateIntr.run(patient_history_params.merge(user: @current_user))
    if outcome.valid?
      return render_success_response(I18n.t("users.therapists_switched"),
                                     { new_therapists: outcome.result.new_therapists_id })
    end

    render_error_response(outcome.errors.full_messages.to_sentence)
  end

  private
  def patient_history_params
    params.require(:patient_history).permit(:comments, :plan_of_care_id, :old_therapists_id, :new_therapists_id)
  end
end
