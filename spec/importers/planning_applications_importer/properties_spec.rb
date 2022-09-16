require "rails_helper"

RSpec.describe "PlanningApplicationsImporter - property" do
  let(:importer) { PlanningApplicationsImporter.new(local_authority_name: "lambeth").call }
  let(:planning_application_url) { "https://paapi-staging-import.s3.eu-west-2.amazonaws.com/PlanningHistoryLambeth.csv" }
  let(:planning_applications_csv) do
    <<-CSV.strip_heredoc
      area, uprn, reference, address, proposal_details, received_at, officer_name, decision, decision_issued_at, map_east, map_north, full, postcode, town, ward_c, ward, property_type, view_documents
      North & Central,111222333444,22/02180/POA,Silverstone Motor Racing Circuit Silverstone Road Biddlesden Buckinghamshire NN12 8TN,"Submission of details for approval in regards to clauses 11b and c Travel Plan Coordinator, 15b (Membership of Travel Plan Steering Group) and 20b (Membership of Transport Strategy Steering Group) of the Section 106 Agreement attached to Outline Planning Permission 17/01840/AOP Silverstone Circuit",14/06/2022,Mrs Rebecca Jarratt,Discharge - Satisfies Requirements,02/09/2022,467520,241616,Silverstone Motor Racing Circuit Silverstone Road Biddlesden Buckinghamshire NN12 8TN,NN12 8TN,Towcester,W049,WINSLOW,"Residential, Dwellings, Detached","https://publicaccess.aylesburyvaledc.gov.uk/online-applications/applicationDetails.do?activeTab=documents&keyVal=AB123"
    CSV
  end

  before do
    create(:local_authority, name: "lambeth")
    stub_request(:get, planning_application_url).to_return(planning_application_response)
  end

  context "when the CSV downloads are successful" do
    let(:planning_application_response) do
      { status: 200, body: planning_applications_csv, headers: { "Content-Type" => "text/csv"} }
    end

    it "imports a new Property object from CSV data" do
      expect { importer }.to change { Property.count }.by(1)
    end

    it "does not import the same uprn twice" do
      create(:property, uprn: "111222333444")

      expect { importer }.to change { Property.count }.by(0)
    end

    describe "attribute update" do
      it "sets the uprn" do
        expect { importer }
          .to change { Property.where(uprn: "111222333444").exists? }.from(false).to(true)
      end

      it "sets the type" do
        expect { importer }
          .to change { Property.where(type: "Residential, Dwellings, Detached").exists? }.from(false).to(true)
      end

      it "sets the ward" do
        expect { importer }
          .to change { Property.where(ward: "W049").exists? }.from(false).to(true)
      end

      it "sets the ward_name" do
        expect { importer }
          .to change { Property.where(ward_name: "WINSLOW").exists? }.from(false).to(true)
      end
    end
  end
end
