# frozen_string_literal: true

class ApiClient < ApplicationRecord
  validates :client_name, presence: true, uniqueness: true

  has_secure_token :client_secret

  def token
    JsonWebToken.encode(client_name:, client_secret:)
  end
end
