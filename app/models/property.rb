# frozen_string_literal: true

class Property < ApplicationRecord
  self.inheritance_column = "inheritance_type"

  has_many :planning_applications_properties, dependent: :destroy
  has_many :planning_applications, through: :planning_applications_properties

  has_one :address, dependent: :delete

  validates_associated :address
  validates :uprn, :type, :code, presence: true

  before_save :set_exponential_notation, :set_missing_zeros

  def set_exponential_notation
    return unless exponential_notation?

    self.uprn = Float(uprn).to_i.to_s
  end

  def set_missing_zeros
    return if twelve_digit_uprn?

    self.uprn = uprn.to_s.rjust(12, "0")
  end

  private

  def exponential_notation?
    uprn.upcase.include?("E+")
  end

  def twelve_digit_uprn?
    uprn.match?(/(\d{12})$/)
  end
end
