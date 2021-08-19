# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  subject { build(:user, :patient) }

  describe "Enums for Dropdown" do
    it { should define_enum_for(:user_type).with_values(%i[patient therapists]) }
    it { should define_enum_for(:gender).with_values(%i[male female]) }
  end

  describe "Associations" do
    it { should have_many(:plan_of_cares) }
    it { should have_many(:goals) }
    it { should have_many(:patient_histories) }
  end

  describe "Validations" do
    %i[name email user_type].each do |field|
      it { should validate_presence_of(field) }
    end

    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_confirmation_of(:email) }
    # HAVE TO WRITE TEST FOR EMAIL FORMAT
  end
end
