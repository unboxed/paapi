class Property < ApplicationRecord
  has_many :planning_applications, dependent: :destroy
  belongs_to :address

  validates :address, presence: true
end
