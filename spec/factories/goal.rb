# frozen_string_literal: true

FactoryBot.define do
  factory :goal do
    name      { Faker::Music.instrument }
    goal_type { ["stg", "ltg"].sample }
  end
end
