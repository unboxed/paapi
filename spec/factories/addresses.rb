# frozen_string_literal: true

FactoryBot.define do
  factory :address do
    full { Faker::Address.full_address }
  end
end
