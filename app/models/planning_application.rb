class PlanningApplication < ApplicationRecord
  belongs_to :local_authority
  belongs_to :property

  delegate :address, to: :property

  validates :reference, :area, :decision_issued_at, :local_authority, :property, presence: true
end
