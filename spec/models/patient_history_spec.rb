# frozen_string_literal: true

require "rails_helper"

RSpec.describe PatientHistory, type: :model do
  subject { build(:patient_history) }

  describe "Associations" do
    it { should belong_to(:plan_of_care) }
    it { should belong_to(:patient).class_name("User").with_foreign_key("patient_id") }
    it { should belong_to(:old_therapists).class_name("User").with_foreign_key("old_therapists_id").optional }
    it { should belong_to(:new_therapists).class_name("User").with_foreign_key("new_therapists_id") }
  end
end
