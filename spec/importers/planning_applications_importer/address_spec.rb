# frozen_string_literal: true

require "rails_helper"

RSpec.describe PlanningApplicationsImporter do
  let(:importer) { described_class.new(local_authority_name: "lambeth").call }
  let(:planning_application_url) { "https://paapi-staging-import.s3.eu-west-2.amazonaws.com/lambeth/PlanningHistoryLambeth.csv" }

  context "when the CSV downloads are successful" do
    let(:planning_applications_csv) do
      <<~CSV
        area, uprn, reference, address, description, received_at, assessor, decision, decision_issued_at, map_east, map_north, full, postcode, town, ward_code, ward_name, property_code, property_type, view_documents
        North & Central,766298059,22/02180/POA,Silverstone Motor Racing Circuit Silverstone Road Biddlesden Buckinghamshire NN12 8TN,"Submission of details for approval in regards to clauses 11b and c Travel Plan Coordinator, 15b (Membership of Travel Plan Steering Group) and 20b (Membership of Transport Strategy Steering Group) of the Section 106 Agreement attached to Outline Planning Permission 17/01840/AOP Silverstone Circuit",14/06/2022,Mrs Rebecca Jarratt,Discharge - Satisfies Requirements,02/09/2022,467520,241616,Silverstone Motor Racing Circuit Silverstone Road Biddlesden Buckinghamshire NN12 8TN,NN12 8TN,Towcester,W037,Ridgeway West,RD03,"Residential, Dwellings, Detached","https://publicaccess.aylesburyvaledc.gov.uk/online-applications/applicationDetails.do?activeTab=documents&keyVal=AB123"
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
        area, uprn, reference, address, description, received_at, assessor, decision, decision_issued_at, map_east, map_north, full, postcode, town, ward_code, ward_name, property_code, property_type, view_documents
        West,766303499,22/06867/PNP6A,Rockwell House Rockwell Lane Buckinghamshire RG9 6NF,"Prior approval application (Part 6, Class A) for construction of agricultural building for storage of hay, concentrate feed, bedding and machinery",2022-07-08T00:00:00,Victoria Burdett,Details Not Required to be Submitted,2022-08-05T00:00:00,479625,188169,             ,RG9 6NF,Henley,W037,Ridgeway West,RD03,"Residential, Dwellings, Detached","https://publicaccess.aylesburyvaledc.gov.uk/online-applications/applicationDetails.do?activeTab=documents&keyVal=AB123"
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
