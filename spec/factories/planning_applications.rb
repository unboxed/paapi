FactoryBot.define do
  factory :planning_application do
    property
    local_authority
    reference { Faker::Base.numerify("##/####/###") }
    area { Faker::Address.state }
    description { Faker::Lorem.unique.sentence }
    received_at { Time.zone.yesterday }
    decision { Faker::Lorem.unique.sentence }
    decision_issued_at { Time.zone.now }
  end
end
