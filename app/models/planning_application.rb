# frozen_string_literal: true

class PlanningApplication < ApplicationRecord
  belongs_to :local_authority
  belongs_to :property

  delegate :address, to: :property

  validates :reference, :area, :description, :received_at, :decision, presence: true
end
