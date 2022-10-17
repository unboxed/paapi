# frozen_string_literal: true

class Address < ApplicationRecord
  has_one :property, dependent: :destroy

  validates :full, presence: true
end
