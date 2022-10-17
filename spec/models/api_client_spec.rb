# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApiClient, type: :model do
  describe "#validations" do
    it "cannot create an api_client without a client_name set" do
      api_client = build(:api_client, client_name: nil)
      api_client.save
      expect(api_client.errors.messages[:client_name][0]).to eq("can't be blank")
    end

    it "generates a new client secret" do
      api_client = build(:api_client)
      api_client.save

      expect(api_client.client_secret).not_to be_empty
    end

    it "must have a unique client_name and client_secret" do
      create(:api_client)
      api_client = build(:api_client)
      api_client.save

      expect(api_client.errors.messages[:client_name][0]).to eq("has already been taken")
    end
  end
end
