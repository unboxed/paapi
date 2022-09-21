class Property < ApplicationRecord
  self.inheritance_column = "inheritance_type"

  has_many :planning_applications, dependent: :destroy
  belongs_to :address

  validates :address, presence: true
  validates_associated :address
end
