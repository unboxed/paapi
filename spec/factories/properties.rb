FactoryBot.define do
  factory :property do
    address
    uprn { Faker::Base.numerify("00######") }
  end
end
