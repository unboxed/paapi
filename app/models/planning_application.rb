# frozen_string_literal: true

class PlanningApplication < ApplicationRecord
  belongs_to :local_authority

  has_many :planning_applications_properties, dependent: :destroy
  has_many :properties, through: :planning_applications_properties

  validates :reference, :area, :description, :received_at, :decision, :decision_issued_at, presence: true
end
