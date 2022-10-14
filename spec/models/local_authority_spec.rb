# frozen_string_literal: true

require "rails_helper"

RSpec.describe LocalAuthority, type: :model do
  context "when validations are run" do
    it "must have the name set" do
      local_authority = build(:local_authority, name: nil)
      local_authority.save

      expect(local_authority.errors.messages).to include(:name)
    end
  end
end
