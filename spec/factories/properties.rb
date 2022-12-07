# frozen_string_literal: true

FactoryBot.define do
  factory :property do
    uprn { Faker::Base.numerify("00######") }
    type { "Residential, Dwellings, Detatched" }
    code { Faker::Base.numerify("RD0#") }

    after(:build) do |p|
      p.address ||= build(:address, property: nil)
    end
  end
end
