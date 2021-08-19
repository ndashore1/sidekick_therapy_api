# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  has_secure_token :auth_token

  enum user_type: %i[patient therapists]
  enum gender: %i[male female]

  # ASSOCIATIONS
  has_many :plan_of_cares, dependent: :destroy
  has_many :goals, dependent: :destroy
  has_many :patient_histories, foreign_key: :patient_id, dependent: :destroy

  # VALIDATIONS
  validates :name, :email, :user_type, presence: true
  validates :email, uniqueness: { case_sensitive: false }, confirmation: true, format: { with: EMAIL_REGXP }
end
