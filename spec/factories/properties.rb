# frozen_string_literal: true

FactoryBot.define do
  factory :property do
    address
    uprn { Faker::Base.numerify("00######") }
    type { "Residential, Dwellings, Detatched" }
    code { Faker::Base.numerify("RD0#") }
  end
end
