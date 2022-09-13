require "rails_helper"

RSpec.describe "PlanningApplications", type: :request, show_exceptions: true  do
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

    context "data" do
      it "returns a list of serialized planning application" do
        planning_application_1 = create(:planning_application)
        planning_application_2 = create(:planning_application)

        get "/api/v1/planning_applications"
        expect(response).to be_successful

        expect(data).to match(
          a_collection_containing_exactly(
            a_hash_including(
              "id" => planning_application_1.id,
              "reference" => planning_application_1.reference,
              "area" => planning_application_1.area,
              "proposal_details" => planning_application_1.proposal_details,
              "received_at" => planning_application_1.received_at.iso8601,
              "officer_name" => planning_application_1.officer_name,
              "decision" => planning_application_1.decision,
              "decision_issued_at" => planning_application_1.decision_issued_at.iso8601,
              "local_authority" => planning_application_1.local_authority.name,
              "created_at" => planning_application_1.created_at.iso8601,
              "view_documents" => planning_application_1.view_documents,
              "uprn" => planning_application_1.property.uprn,
              "address" => planning_application_1.property.address.full,
            ),
            a_hash_including(
              "id" => planning_application_2.id,
              "reference" => planning_application_2.reference,
              "area" => planning_application_2.area,
              "proposal_details" => planning_application_2.proposal_details,
              "received_at" => planning_application_2.received_at.iso8601,
              "officer_name" => planning_application_2.officer_name,
              "decision" => planning_application_2.decision,
              "decision_issued_at" => planning_application_2.decision_issued_at.iso8601,
              "local_authority" => planning_application_2.local_authority.name,
              "created_at" => planning_application_2.created_at.iso8601,
              "view_documents" => planning_application_2.view_documents,
              "uprn" => planning_application_2.property.uprn,
              "address" => planning_application_2.property.address.full,
            )
          )
        )
      end
    end
  end
end
