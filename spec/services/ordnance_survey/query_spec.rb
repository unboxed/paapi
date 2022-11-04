# frozen_string_literal: true

require "rails_helper"

RSpec.describe OrdnanceSurvey::Query do
  let(:query) { described_class.new }

  describe "#fetch" do
    context "when the request is successful" do
      context "when a valid uprn is supplied" do
        before do
          stub_ordnance_survey_api_request_for("200010019924").to_return(ordnance_survey_api_response(:ok,
                                                                                                      "200010019924"))
        end

        it "returns an array with ward type, ward name and parish name (type NPC)" do
          expect(query.fetch("200010019924")).to eq(JSON.parse(file_fixture("200010019924.json").read))
        end
      end
    end

    context "when the request is unsuccessful" do
      context "when a uprn is not found" do
        before do
          stub_ordnance_survey_api_request_for("10008104351").to_return(ordnance_survey_api_response(:not_found,
                                                                                                     "no_result"))
        end

        it "returns an empty array" do
          expect(query.fetch("20001001992")).to eq([])
        end
      end

      context "when the API does not respond" do
        before do
          stub_ordnance_survey_api_request_for("200010019924").to_timeout
        end

        it "returns an empty array" do
          expect(query.fetch("200010019924")).to eq([])
        end
      end

      context "when the API is returning an internal server error" do
        before do
          stub_ordnance_survey_api_request_for("200010019924").to_return(ordnance_survey_api_response(:internal_server_error))
        end

        it "returns an empty array" do
          expect(query.fetch("200010019924")).to eq([])
        end
      end

      context "when the API can't find the resource" do
        before do
          stub_ordnance_survey_api_request_for("200010019924").to_return(ordnance_survey_api_response(:not_acceptable))
        end

        it "returns an empty array" do
          expect(query.fetch("200010019924")).to eq([])
        end
      end
    end
  end
end