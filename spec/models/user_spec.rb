# frozen_string_literal: true

require "rails_helper"

RSpec.describe User do
  it "not be created without a local authority" do
    user_without_local_authority = build(:user, local_authority: nil)
    expect(user_without_local_authority).not_to be_valid
  end
end
