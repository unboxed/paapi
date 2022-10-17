# frozen_string_literal: true

module AuthHelper
  def self.auth_headers(token)
    {
      "AUTHORIZATION" => token.to_s
    }
  end
end
