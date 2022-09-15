class PlanningApplication < ApplicationRecord
  belongs_to :local_authority
  belongs_to :property

  delegate :address, to: :property

  validates :reference, :area, :proposal_details, :received_at, :decision, :decision_issued_at, :local_authority, :property, presence: true
end
