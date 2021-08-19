# frozen_string_literal: true

class PatientHistories::CreateIntr < ApplicationInteraction
  object :user
  string :plan_of_care_id, :old_therapists_id, :new_therapists_id
  string :comments, default: nil

  def execute
    patient_history = user.patient_histories.build(inputs.except(:user))
    errors.merge!(patient_history.errors) unless patient_history.save
    patient_history
  end
end
