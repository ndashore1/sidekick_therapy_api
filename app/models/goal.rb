# frozen_string_literal: true

class Goal < ApplicationRecord
  # Type of Goal (STG- Short Term Goal, LTG - Long Term Goal)
  enum goal_type: %i[stg ltg]

  # ASSOCIATIONS
  belongs_to :user
  belongs_to :plan_of_care

  # VALIDATIONS
  validates :name, :goal_type, presence: true

  # Return the list of words that pronounced incorrectly.
  def observed_errors
    return "" if note.blank?

    note.values.reject(&:blank?).collect { |h| h[:errors] }.compact.join(", ")
  rescue StandardError => e
    Rails.logger.error e
    ""
  end

  def pronoun_result
    return [0, 0] if note.blank? && !(note.is_a? Hash)

    observation = note.values.reject(&:blank?).collect { |e| e[:observation] }.join(" ")
    # Return Correct and Incorrect pronounciation count.
    [observation.count("+"), observation.count("-")]
  rescue StandardError => e
    Rails.logger.error e
    [0, 0]
  end
end
