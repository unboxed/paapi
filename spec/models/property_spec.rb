# frozen_string_literal: true

require "rails_helper"

RSpec.describe Property, type: :model do
  context "when validations are run" do
    it "must have the address set" do
      property = build(:property, address: nil)
      property.save

      expect(property.errors.messages).to include(:address)
    end

    it "must have the uprn set" do
      property = build(:property, uprn: nil)
      property.save

      expect(property.errors.messages).to include(:uprn)
    end

    it "must have the type set" do
      property = build(:property, type: nil)
      property.save

      expect(property.errors.messages).to include(:type)
    end

    it "must have the code set" do
      property = build(:property, code: nil)
      property.save

      expect(property.errors.messages).to include(:code)
    end
  end
end
