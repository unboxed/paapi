# frozen_string_literal: true

require "rails_helper"

RSpec.describe OrdnanceSurvey::Client do
  let(:client) { described_class.new }

  describe "#call" do
    let(:faraday_connection) { spy }
    let(:url) { "https://api.os.uk/search/places/v1/" }

    before do
      allow(Faraday).to receive(:new).with(url:).and_yield(faraday_connection)
      allow(client).to receive(:api_key).and_return("key")
    end

    it "makes a Faraday connection" do
      client.call("200010019924")

      expect(faraday_connection).to have_received(:get).with("uprn?uprn=200010019924&output_srs=EPSG:4326&key=key")
    end
  end
end
