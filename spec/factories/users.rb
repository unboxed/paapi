# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    local_authority do
      LocalAuthority.find_by(name: "buckinghamshire") || create(:local_authority)
    end
    email { "test@example.com" }
    password { "secretpassword" }
  end
end
