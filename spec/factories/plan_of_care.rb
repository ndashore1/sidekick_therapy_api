# frozen_string_literal: true

FactoryBot.define do
  factory :plan_of_care do
    title { Faker::Music.album }
  end
end
