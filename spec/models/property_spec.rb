require "rails_helper"

RSpec.describe Property, type: :model do
  context "#validations" do
    it "must have the address set" do
      property = build(:property, address: nil)
      property.save

      expect(property.errors.messages).to include(:address)
    end
  end
end
