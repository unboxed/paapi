# frozen_string_literal: true

class ApiClient < ApplicationRecord
  has_one :local_authority, dependent: :destroy
  validates :client_name, presence: true, uniqueness: true

  has_secure_token :client_secret

  def token
    JsonWebToken.encode(client_name:, client_secret:)
  end
end
