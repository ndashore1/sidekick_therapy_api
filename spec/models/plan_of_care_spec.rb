# frozen_string_literal: true

require "rails_helper"

RSpec.describe PlanOfCare, type: :model do
  subject { build(:plan_of_care) }

  describe "Associations" do
    it { should belong_to(:user) }
    it { should have_many(:goals) }
    it { should have_many(:patient_histories) }
  end

  describe "Validations" do
    it { should validate_presence_of(:title) }
  end

  describe "Nested Attributes" do
    it { should accept_nested_attributes_for(:patient_histories) }
  end
end
