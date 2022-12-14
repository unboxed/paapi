# frozen_string_literal: true

require "rails_helper"

RSpec.describe Address do
  context "when validations are run" do
    it "must have a full set" do
      address = build(:address, full: nil)
      address.save

      expect(address.errors.messages).to include(:full)
    end
  end
end
