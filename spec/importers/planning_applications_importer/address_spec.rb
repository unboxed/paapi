require "rails_helper"

RSpec.describe "PlanningApplicationsImporter - address" do
  let(:importer) { PlanningApplicationsImporter.new(local_authority_name: "lambeth").call }
  let(:planning_application_url) { "https://paapi-staging-import.s3.eu-west-2.amazonaws.com/lambeth/PlanningHistoryLambeth.csv" }

  context "when the CSV downloads are successful" do
    let(:planning_applications_csv) do
      <<-CSV.strip_heredoc
        area, uprn, reference, address, proposal_details, received_at, officer_name, decision, decision_issued_at, map_east, map_north, full, postcode, town, ward_code, ward_name, property_code, property_type, view_documents
        North & Central,766298059,22/02180/POA,Silverstone Motor Racing Circuit Silverstone Road Biddlesden Buckinghamshire NN12 8TN,"Submission of details for approval in regards to clauses 11b and c Travel Plan Coordinator, 15b (Membership of Travel Plan Steering Group) and 20b (Membership of Transport Strategy Steering Group) of the Section 106 Agreement attached to Outline Planning Permission 17/01840/AOP Silverstone Circuit",14/06/2022,Mrs Rebecca Jarratt,Discharge - Satisfies Requirements,02/09/2022,467520,241616,Silverstone Motor Racing Circuit Silverstone Road Biddlesden Buckinghamshire NN12 8TN,NN12 8TN,Towcester,W037,Ridgeway West,RD03,"Residential, Dwellings, Detached","https://publicaccess.aylesburyvaledc.gov.uk/online-applications/applicationDetails.do?activeTab=documents&keyVal=AB123"
      CSV
    end

    before do
      create(:local_authority, name: "lambeth")
      stub_request(:get, planning_application_url).to_return(planning_application_response)
    end

    let(:planning_application_response) do
      { status: 200, body: planning_applications_csv, headers: { "Content-Type" => "text/csv"} }
    end

    it "import creates an Address object from CSV data" do
      expect { importer }.to change { Address.count }.by(1)
    end

    it "imports full address" do
      expect { importer }.to change {
        Address.where(full: "Silverstone Motor Racing Circuit Silverstone Road Biddlesden Buckinghamshire NN12 8TN").exists?
      }.from(false).to(true)
    end

    it "imports postcode" do
      expect { importer }.to change {
        Address.where(postcode: "NN12 8TN").exists?
      }.from(false).to(true)
    end

    it "imports town" do
      expect { importer }.to change {
        Address.where(town: "Towcester").exists?
      }.from(false).to(true)
    end

    it "imports map_east" do
      expect { importer }.to change {
        Address.where(map_east: "467520").exists?
      }.from(false).to(true)
    end

    it "imports map_north" do
      expect { importer }.to change {
        Address.where(map_north: "241616").exists?
      }.from(false).to(true)
    end

    it "sets the ward" do
      expect { importer }.to change {
        Address.where(ward_code: "W037").exists?
      }.from(false).to(true)
    end

    it "sets the ward_name" do
      expect { importer }.to change {
        Address.where(ward_name: "Ridgeway West").exists?
      }.from(false).to(true)
    end
  end
end
