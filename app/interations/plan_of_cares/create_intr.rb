# frozen_string_literal: true

class PlanOfCares::CreateIntr < ApplicationInteraction
  object :user

  string :title
  integer :therapists_id, default: nil

  def execute
    plan_of_care = user.plan_of_cares.build(inputs.merge(patient_histories_attributes).except(:therapists_id))
    errors.merge!(plan_of_care.errors) unless plan_of_care.save

    plan_of_care
  end

  private
  def patient_histories_attributes
    { patient_histories_attributes: if therapists_id
                                      [{
                                        patient_id: user.id,
                                        new_therapists_id: therapists_id
                                      }]
                                    else
                                      []
                                    end
    }
  end
end
