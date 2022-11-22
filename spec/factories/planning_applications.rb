# frozen_string_literal: true

FactoryBot.define do
  factory :planning_application do
    local_authority
    reference { Faker::Base.numerify("##/####/###") }
    area { Faker::Address.state }
    description { Faker::Lorem.unique.sentence }
    received_at { Time.zone.yesterday }
    decision { Faker::Lorem.unique.sentence }
    decision_issued_at { Time.zone.now }

    after(:create) do |pa|
      pa.properties << build(:property)
    end
  end
end
