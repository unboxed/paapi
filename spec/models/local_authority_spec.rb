# frozen_string_literal: true

require "rails_helper"

RSpec.describe LocalAuthority, type: :model do
  it "raises an error with wrong name" do
    expect { build(:local_authority, name: "local_authority") }
      .to raise_error(ArgumentError)
      .with_message(/is not a valid name/)
  end

  context "when validations are run" do
    it "must have the name set" do
      local_authority = build(:local_authority, name: nil)
      local_authority.save

      expect(local_authority.errors.messages).to include(:name)
    end
  end
end
