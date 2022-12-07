# frozen_string_literal: true

class Address < ApplicationRecord
  belongs_to :property

  validates :full, presence: true

  before_save :set_lat_and_long

  def set_lat_and_long
    self.longitude, self.latitude = NationalGrid.os_ng_to_wgs84(map_east.to_i, map_north.to_i)
  end
end
