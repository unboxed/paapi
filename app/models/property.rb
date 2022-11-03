# frozen_string_literal: true

class Property < ApplicationRecord
  self.inheritance_column = "inheritance_type"

  has_many :planning_applications, dependent: :destroy
  belongs_to :address

  validates_associated :address
  validates :uprn, :type, :code, presence: true
end
