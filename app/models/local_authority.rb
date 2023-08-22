# frozen_string_literal: true

class LocalAuthority < ApplicationRecord
  has_many :planning_applications, dependent: :destroy
  has_many :csv_uploads, dependent: :nullify
  belongs_to :api_client, optional: true

  validates :name, presence: true

  enum name: {
    lambeth: "lambeth",
    southwark: "southwark",
    buckinghamshire: "buckinghamshire"
  }
end
