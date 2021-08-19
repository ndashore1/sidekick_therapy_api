# frozen_string_literal: true

class PlanOfCare < ApplicationRecord
  # ASSOCIATIONS
  belongs_to :user
  has_many :goals, dependent: :destroy
  has_many :patient_histories, dependent: :destroy

  # VALIDATIONS
  validates :title, presence: true

  accepts_nested_attributes_for :patient_histories
end
