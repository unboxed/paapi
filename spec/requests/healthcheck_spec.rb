# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Healthcheck", show_exceptions: true do
  it "returns 200 when trying to hit healthcheck endpoint" do
    get healthcheck_path

    expect(response).to be_ok
  end
end
