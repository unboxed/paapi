# frozen_string_literal: true

class Address < ApplicationRecord
  has_one :property, dependent: :destroy

  validates :full, presence: true

  after_create :lat_and_long

  def lat_and_long
    return if lat_and_long?

    uprn_place = OrdnanceSurvey::Query.new.fetch(property&.uprn)

    return if uprn_place.nil?

    update!(latitude: uprn_place.first["DPA"]["LAT"], longitude: uprn_place.first["DPA"]["LNG"])
  end

  def lat_and_long?
    latitude.present? && longitude.present?
  end
end
