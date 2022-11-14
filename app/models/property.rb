# frozen_string_literal: true

class Property < ApplicationRecord
  self.inheritance_column = "inheritance_type"

  has_many :planning_applications, dependent: :destroy
  belongs_to :address

  validates_associated :address
  validates :uprn, :type, :code, presence: true

  before_save :set_exponential_notation

  def set_exponential_notation
    return unless exponential_notation?

    self.uprn = Float(uprn).to_i.to_s
  end

  private

  def exponential_notation?
    uprn.upcase.include?("E+")
  end
end
