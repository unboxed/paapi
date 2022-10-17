# frozen_string_literal: true

require "rails_helper"

RSpec.describe "PlanningApplications", type: :request, show_exceptions: true do
  describe "GET /index" do
    let(:data) { json["data"] }

    describe "format" do
      let(:access_control_allow_origin) { response.headers["Access-Control-Allow-Origin"] }
      let(:access_control_allow_methods) { response.headers["Access-Control-Allow-Methods"] }
      let(:access_control_allow_headers) { response.headers["Access-Control-Allow-Headers"] }

      it "responds to JSON" do
        get "/api/v1/planning_applications"
        expect(response).to be_successful
      end

      it "sets CORS headers" do
        get "/api/v1/planning_applications"

        expect(response).to be_successful
        expect(access_control_allow_origin).to eq("*")
        expect(access_control_allow_methods).to eq("GET")
        expect(access_control_allow_headers).to eq("Origin, X-Requested-With, Content-Type, Accept")
      end
    end

    it "returns an empty response if no planning application" do
      get "/api/v1/planning_applications"

      expect(response).to have_http_status(:success)
      expect(data).to eq([])
    end

    context "when has 10 planning_applications" do
      before do
        create_list(:planning_application, 10)

        get "/api/v1/planning_applications"
      end

      it "returns all planning_applications" do
        expect(data.size).to eq(10)
      end

      it "returns status code 200" do
        expect(response).to have_http_status(:success)
      end
    end

    context "when response is successful" do
      # rubocop:disable RSpec/ExampleLength
      it "returns a list of serialized planning application" do
        planning_application1 = create(:planning_application)
        planning_application2 = create(:planning_application)

        get "/api/v1/planning_applications"
        expect(response).to be_successful

        expect(data).to match(
          a_collection_containing_exactly(
            a_hash_including(
              "id" => planning_application1.id,
              "reference" => planning_application1.reference,
              "area" => planning_application1.area,
              "description" => planning_application1.description,
              "received_at" => planning_application1.received_at.iso8601,
              "assessor" => planning_application1.assessor,
              "decision" => planning_application1.decision,
              "decision_issued_at" => planning_application1.decision_issued_at.iso8601,
              "local_authority" => planning_application1.local_authority.name,
              "created_at" => planning_application1.created_at.iso8601,
              "view_documents" => planning_application1.view_documents,
              "property" => a_hash_including(
                "uprn" => planning_application1.property.uprn,
                "code" => planning_application1.property.code,
                "type" => planning_application1.property.type
              ),
              "address" => planning_application1.property.address.full
            ),
            a_hash_including(
              "id" => planning_application2.id,
              "reference" => planning_application2.reference,
              "area" => planning_application2.area,
              "description" => planning_application2.description,
              "received_at" => planning_application2.received_at.iso8601,
              "assessor" => planning_application2.assessor,
              "decision" => planning_application2.decision,
              "decision_issued_at" => planning_application2.decision_issued_at.iso8601,
              "local_authority" => planning_application2.local_authority.name,
              "created_at" => planning_application2.created_at.iso8601,
              "view_documents" => planning_application2.view_documents,
              "property" => a_hash_including(
                "uprn" => planning_application2.property.uprn,
                "code" => planning_application2.property.code,
                "type" => planning_application2.property.type
              ),
              "address" => planning_application2.property.address.full
            )
          )
        )
      end
      # rubocop:enable RSpec/ExampleLength
    end

    context "when search by uprn" do
      let(:property1) { create(:property, uprn: "abcd") }
      let(:property2) { create(:property, uprn: "1234") }

      it "returns a list of serialized planning application" do
        create(:planning_application, property: property1)
        create(:planning_application, property: property2)

        get "/api/v1/planning_applications", params: { uprn: "1234" }

        expect(response).to be_successful
        expect(data.first["property"]["uprn"]).to eq("1234")
      end
    end
  end
end
