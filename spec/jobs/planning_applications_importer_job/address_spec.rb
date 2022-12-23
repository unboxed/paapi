# frozen_string_literal: true

require "rails_helper"

RSpec.describe PlanningApplicationsImporterJob do
  let(:importer) { described_class.perform_now(local_authority_name: "lambeth") }
  let(:planning_application_url) { "https://paapi-staging-import.s3.eu-west-2.amazonaws.com/lambeth/PlanningHistoryLambeth.csv" }

  context "when the CSV downloads are successful" do
    let(:planning_applications_csv) do
      <<~CSV
        reference, application_type_code, application_type, area, description, received_at, assessor, reviewer, decision, decision_issued_at, validated_at, view_documents, uprn, code, type, address, full, town, postcode, map_east, map_north, latitude, longitude, ward_code, ward_name
        22/02180/POA,FA,Full Application,North & Central,"Submission of details for approval in regards to clauses 11b and c Travel Plan Coordinator, 15b (Membership of Travel Plan Steering Group) and 20b (Membership of Transport Strategy Steering Group) of the Section 106 Agreement attached to Outline Planning Permission 17/01840/AOP Silverstone Circuit",14/06/2022,Mrs Rebecca Jarratt,,Discharge - Satisfies Requirements,02/09/2022,,"https://publicaccess.aylesburyvaledc.gov.uk/online-applications/applicationDetails.do?activeTab=documents&keyVal=AB123",766298059,RD03,"Residential, Dwellings, Detached",Silverstone Motor Racing Circuit Silverstone Road Biddlesden Buckinghamshire NN12 8TN,Silverstone Motor Racing Circuit Silverstone Road Biddlesden Buckinghamshire NN12 8TN,Towcester,NN12 8TN,467520,241616,,,W037,Ridgeway West
      CSV
    end
    let(:planning_application_response) do
      { status: 200, body: planning_applications_csv, headers: { "Content-Type" => "text/csv" } }
    end

    before do
      create(:local_authority, name: "lambeth")
      stub_request(:get, planning_application_url).to_return(planning_application_response)
    end

    it "import creates an Address object from CSV data" do
      expect { importer }.to change(Address, :count).by(1)
    end

    it "imports full address" do
      expect { importer }.to change {
        Address.exists?(full: "Silverstone Motor Racing Circuit Silverstone Road Biddlesden Buckinghamshire NN12 8TN")
      }.from(false).to(true)
    end

    it "imports postcode" do
      expect { importer }.to change {
        Address.exists?(postcode: "NN12 8TN")
      }.from(false).to(true)
    end

    it "imports town" do
      expect { importer }.to change {
        Address.exists?(town: "Towcester")
      }.from(false).to(true)
    end

    it "imports map_east" do
      expect { importer }.to change {
        Address.exists?(map_east: "467520")
      }.from(false).to(true)
    end

    it "imports map_north" do
      expect { importer }.to change {
        Address.exists?(map_north: "241616")
      }.from(false).to(true)
    end

    it "sets the ward" do
      expect { importer }.to change {
        Address.exists?(ward_code: "W037")
      }.from(false).to(true)
    end

    it "sets the ward_name" do
      expect { importer }.to change {
        Address.exists?(ward_name: "Ridgeway West")
      }.from(false).to(true)
    end
  end

  context "when full address is blank" do
    let(:planning_applications_without_full_address_csv) do
      <<~CSV
        reference, application_type_code, application_type, area, description, received_at, assessor, reviewer, decision, decision_issued_at, validated_at, view_documents, uprn, code, type, address, full, town, postcode, map_east, map_north, latitude, longitude, ward_code, ward_name
        22/06867/PNP6A,FA,Full Application,West,"Prior approval application (Part 6, Class A) for construction of agricultural building for storage of hay, concentrate feed, bedding and machinery",2022-07-08T00:00:00,Victoria Burdett,,Details Not Required to be Submitted,2022-08-05T00:00:00,,"https://publicaccess.aylesburyvaledc.gov.uk/online-applications/applicationDetails.do?activeTab=documents&keyVal=AB123",766303499,RD03,"Residential, Dwellings, Detached",Rockwell House Rockwell Lane Buckinghamshire RG9 6NF,,Henley,RG9 6NF,479625,188169,,,W037,Ridgeway West
      CSV
    end

    let(:planning_application_response) do
      { status: 200, body: planning_applications_without_full_address_csv, headers: { "Content-Type" => "text/csv" } }
    end

    before do
      create(:local_authority, name: "lambeth")
      stub_request(:get, planning_application_url).to_return(planning_application_response)
    end

    it "imports full address from planning application address" do
      expect { importer }.to change {
        Address.exists?(full: "Rockwell House Rockwell Lane Buckinghamshire RG9 6NF")
      }.from(false).to(true)
    end
  end
end
