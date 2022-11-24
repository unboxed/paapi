# frozen_string_literal: true

require "rails_helper"

RSpec.describe "PlanningApplications", type: :request, show_exceptions: true do
  describe "POST /api/v1/planning_applications" do
    let(:api_client) { create(:api_client) }
    let(:headers) { AuthHelper.auth_headers(api_client.token) }
    let(:reference) { "AB/22/1234/FA" }

    let(:planning_application_attributes) do
      {
        reference:,
        application_type_code: "FA",
        application_type: "Full Application",
        area: "South & East",
        description: "Demolition of existing first floor.",
        received_at: "2022-05-30",
        assessor: "Keira Jones",
        reviewer: "Leila Smith",
        decision: "Conditional permission",
        decision_issued_at: "2022-10-14",
        validated_at: "2022-06-23",
        view_documents: "https://example.gov.uk"
      }
    end

    let(:property_attributes) do
      {
        uprn: "123456789123",
        code: "RD02",
        type: "Residential, Dwellings, Detached"
      }
    end

    let(:address_attributes) do
      {
        full: "123 High Street, Big City, AB3 4EF",
        town: "Big City",
        postcode: "AB3 4EF",
        map_east: "123456",
        map_north: "654321",
        latitude: "55.703226",
        longitude: "-6.403439",
        ward_code: "W16",
        ward_name: "Ward 16"
      }
    end

    let(:params) do
      {
        planning_applications: [
          **planning_application_attributes,
          **property_attributes,
          **address_attributes
        ]
      }
    end

    before do
      create(:local_authority, name: "buckinghamshire", api_client:)
    end

    def parse_date(value)
      Date.parse(value)
    rescue Date::Error
      value
    end

    it "creates planning applications" do
      expect { post "/api/v1/planning_applications", params:, headers: }
        .to change(PlanningApplication, :count)
        .by(1)
    end

    it "creates property" do
      expect { post "/api/v1/planning_applications", params:, headers: }
        .to change(Property, :count)
        .by(1)
    end

    it "creates address" do
      expect { post "/api/v1/planning_applications", params:, headers: }
        .to change(Address, :count)
        .by(1)
    end

    it "saves planning application attributes" do
      post("/api/v1/planning_applications", params:, headers:)

      expect(PlanningApplication.last).to have_attributes(
        planning_application_attributes.transform_values { |v| parse_date(v) }
      )
    end

    it "saves property attributes" do
      post("/api/v1/planning_applications", params:, headers:)

      expect(Property.last).to have_attributes(property_attributes)
    end

    it "saves address attributes" do
      post("/api/v1/planning_applications", params:, headers:)

      expect(Address.last).to have_attributes(address_attributes)
    end

    it "returns 201" do
      post("/api/v1/planning_applications", params:, headers:)

      expect(json).to eq({ "message" => "Applications created" })

      expect(response).to have_http_status(:created)
    end

    context "when params are invalid" do
      let(:reference) { nil }

      it "returns 400" do
        post("/api/v1/planning_applications", params:, headers:)

        expect(response).to have_http_status(:bad_request)
      end

      it "returns error message" do
        post("/api/v1/planning_applications", params:, headers:)

        expect(json).to eq({ "message" => "Validation failed: Reference can't be blank" })
      end
    end
  end

  describe "GET /index" do
    let(:data) { json["data"] }

    it "returns an error response if uprn is not provided" do
      get "/api/v1/planning_applications"

      expect(response.code).to eq("400")
      expect(json).to eq({ "message" => "UPRN must be present to proceed" })
    end

    it "returns an error response if uprn is not a number 12 digits" do
      get "/api/v1/planning_applications", params: { uprn: "as234" }

      expect(response.code).to eq("400")
      expect(json).to eq({ "message" => "UPRN must be a number 12 character" })
    end

    describe "when search by uprn" do
      let(:access_control_allow_origin) { response.headers["Access-Control-Allow-Origin"] }
      let(:access_control_allow_methods) { response.headers["Access-Control-Allow-Methods"] }
      let(:access_control_allow_headers) { response.headers["Access-Control-Allow-Headers"] }

      let(:property1) { create(:property, uprn: "123456789125") }
      let(:property2) { create(:property, uprn: "123456789123") }

      before do
        create(:planning_application, properties: [property1])
        create(:planning_application, properties: [property2])
        create(:planning_application, properties: [property2])

        get "/api/v1/planning_applications", params: { uprn: }
      end

      context "when there is a record with this uprn" do
        let(:uprn) { "123456789123" }

        it "returns status code 200" do
          expect(response).to have_http_status(:success)
        end

        it "sets CORS headers" do
          expect(response).to be_successful
          expect(access_control_allow_origin).to eq("*")
          expect(access_control_allow_methods).to eq("GET")
          expect(access_control_allow_headers).to eq("Origin, X-Requested-With, Content-Type, Accept")
        end

        it "returns only the two planning_applications" do
          expect(data.size).to eq(2)
        end

        # rubocop:disable RSpec/ExampleLength
        it "returns a list of serialized planning application" do
          planning_application1 = Property.find_by(uprn:).planning_applications.first
          planning_application2 = Property.find_by(uprn:).planning_applications.last

          expect(data).to match(
            a_collection_containing_exactly(
              a_hash_including(
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
                "properties" => a_collection_containing_exactly(
                  a_hash_including(
                    "uprn" => planning_application1.properties.first.uprn,
                    "code" => planning_application1.properties.first.code,
                    "type" => planning_application1.properties.first.type,
                    "address" => planning_application1.properties.first.address.full
                  ),
                  a_hash_including(
                    "uprn" => planning_application1.properties.second.uprn,
                    "code" => planning_application1.properties.second.code,
                    "type" => planning_application1.properties.second.type,
                    "address" => planning_application1.properties.second.address.full
                  )
                )
              ),
              a_hash_including(
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
                "properties" => a_collection_containing_exactly(
                  a_hash_including(
                    "uprn" => planning_application2.properties.first.uprn,
                    "code" => planning_application2.properties.first.code,
                    "type" => planning_application2.properties.first.type,
                    "address" => planning_application2.properties.first.address.full
                  ),
                  a_hash_including(
                    "uprn" => planning_application2.properties.second.uprn,
                    "code" => planning_application2.properties.second.code,
                    "type" => planning_application2.properties.second.type,
                    "address" => planning_application2.properties.second.address.full
                  )
                )
              )
            )
          )
        end
        # rubocop:enable RSpec/ExampleLength
      end

      context "when there is not a record with this uprn" do
        let(:uprn) { "123456789120" }

        it "returns an error response with unable to find record" do
          expect(response.code).to eq("404")
          expect(json).to eq({ "message" => "Unable to find record" })
        end
      end
    end
  end
end
