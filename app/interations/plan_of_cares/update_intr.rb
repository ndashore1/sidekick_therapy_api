# frozen_string_literal: true

class PlanOfCares::UpdateIntr < ApplicationInteraction
  object :plan_of_care

  string :title
  integer :therapists_id, default: nil

  validate :no_patient_history

  def execute
    unless plan_of_care.update(inputs.merge(patient_histories_attributes).except(:therapists_id, :plan_of_care))
      errors.merge! plan_of_care.errors
    end

    plan_of_care
  end

  private
  def patient_histories_attributes
    { patient_histories_attributes: if therapists_id
                                      [{
                                        patient_id: plan_of_care.user_id,
                                        new_therapists_id: therapists_id
                                      }]
                                    else
                                      []
                                    end
    }
  end

  def no_patient_history
    if therapists_id && plan_of_care.patient_histories.present?
      errors.add(:base, I18n.t("therapists_already_assigned"))
    end
  end
end
