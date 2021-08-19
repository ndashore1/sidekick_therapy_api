# frozen_string_literal: true

class PlanOfCareSerializer < ActiveModel::Serializer
  attributes :id, :title, :goals, :old_therapists, :new_therapists

  has_many :goals

  def old_therapists
    object.patient_histories.last.try(:old_therapists)
  end

  def new_therapists
    object.patient_histories.last.try(:new_therapists)
  end
end
