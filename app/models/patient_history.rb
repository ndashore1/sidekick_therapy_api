# frozen_string_literal: true

class PatientHistory < ApplicationRecord
  # ASSOCIATIONS
  belongs_to :plan_of_care
  belongs_to :patient, class_name: "User", foreign_key: :patient_id
  belongs_to :old_therapists, class_name: "User", foreign_key: :old_therapists_id, optional: true
  belongs_to :new_therapists, class_name: "User", foreign_key: :new_therapists_id
end
