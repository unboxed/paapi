# frozen_string_literal: true

FactoryBot.define do
  factory :address do
    property
    full { Faker::Address.full_address }
  end
end
