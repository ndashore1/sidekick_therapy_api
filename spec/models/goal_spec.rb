# frozen_string_literal: true

require "rails_helper"

RSpec.describe Goal, type: :model do
  subject { build(:goal) }

  describe "Enum" do
    it { should define_enum_for(:goal_type).with_values(%i[stg ltg]) }
  end

  describe "Associations" do
    it { should belong_to(:user) }
    it { should belong_to(:plan_of_care) }
  end
end
