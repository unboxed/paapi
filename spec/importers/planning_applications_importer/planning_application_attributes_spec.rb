# frozen_string_literal: true

require "rails_helper"

RSpec.describe PlanningApplicationsImporter do
  let(:importer) { described_class.new(local_authority_name: "lambeth").call }
  let(:planning_application_url) { "https://paapi-staging-import.s3.eu-west-2.amazonaws.com/lambeth/PlanningHistoryLambeth.csv" }
  let(:planning_applications_csv) do
    <<~CSV
      area, uprn, reference, address, description, received_at, assessor, decision, decision_issued_at, map_east, map_north, full, postcode, town, ward_code, ward_name, property_code, property_type, view_documents
      Central,766298059,22/02180/POA,1 Silverstone Road NN12 8TN,"Submission from Silverstone",14/06/2022,Ms May Lo,Discharge - Satisfies Requirements,02/09/2022,467520,241616,Silverstone Silverstone Road Biddlesden Buckinghamshire NN12 8TN,NN12 8TN,Towcester,W037,Ridgeway West,RD03,"Residential, Dwellings, Detached","https://publicaccess.aylesburyvaledc.gov.uk/online-applications/applicationDetails.do?activeTab=documents&keyVal=AB123"
    CSV
  end

  let(:planning_application_response) do
    { status: 200, body: planning_applications_csv, headers: { "Content-Type" => "text/csv" } }
  end

  before do
    create(:local_authority, name: "lambeth")
    stub_request(:get, planning_application_url).to_return(planning_application_response)
  end

  it "imports reference" do
    expect { importer }.to change {
      PlanningApplication.exists?(reference: "22/02180/POA")
    }.from(false).to(true)
  end

  it "imports area" do
    expect { importer }.to change {
      PlanningApplication.exists?(area: "Central")
    }.from(false).to(true)
  end

  it "imports description" do
    expect { importer }.to change {
      PlanningApplication.exists?(description: "Submission from Silverstone")
    }.from(false).to(true)
  end

  it "imports received_at" do
    expect { importer }.to change {
      PlanningApplication.exists?(received_at: "14/06/2022")
    }.from(false).to(true)
  end

  it "imports officer_name" do
    expect { importer }.to change {
      PlanningApplication.exists?(assessor: "Ms May Lo")
    }.from(false).to(true)
  end

  it "imports decision" do
    expect { importer }.to change {
      PlanningApplication.exists?(decision: "Discharge - Satisfies Requirements")
    }.from(false).to(true)
  end

  it "imports decision issued at" do
    expect { importer }.to change {
      PlanningApplication.exists?(decision_issued_at: "02/09/2022")
    }.from(false).to(true)
  end

  it "imports view documents" do
    expect { importer }.to change {
      PlanningApplication.exists?(view_documents: "https://publicaccess.aylesburyvaledc.gov.uk/online-applications/applicationDetails.do?activeTab=documents&keyVal=AB123")
    }.from(false).to(true)
  end
end
