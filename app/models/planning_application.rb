class PlanningApplication < ApplicationRecord
  belongs_to :local_authority
  belongs_to :property

  validates :reference, :area, :proposal, :received_at, :decision, :decision_issued_at, :local_authority, :property, presence: true
end
