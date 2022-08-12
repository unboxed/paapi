class Address < ApplicationRecord
  has_one :property

  validates :full, presence: true
end
