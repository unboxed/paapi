require "rails_helper"

RSpec.describe "PlanningApplicationsImporter - Attributes" do
  let(:importer) { PlanningApplicationsImporter.new(local_authority_name: "lambeth").call }
  let(:planning_application_url) { "https://paapi-staging-import.s3.eu-west-2.amazonaws.com/PlanningHistoryLambeth.csv" }
  let(:planning_applications_csv) do
    <<-CSV.strip_heredoc
      area, uprn, reference, address, proposal_details, received_at, officer_name, decision, decision_issued_at, map_east, map_north, full, postcode, town, ward_c, ward, property_type, view_documents
      Central,766298059,22/02180/POA,1 Silverstone Road NN12 8TN,"Submission from Silverstone",14/06/2022,Ms May Lo,Discharge - Satisfies Requirements,02/09/2022,467520,241616,Silverstone Silverstone Road Biddlesden Buckinghamshire NN12 8TN,NN12 8TN,Towcester,W049,WINSLOW,"Residential, Dwellings, Detached","https://publicaccess.aylesburyvaledc.gov.uk/online-applications/applicationDetails.do?activeTab=documents&keyVal=AB123"
    CSV
  end

  let(:planning_application_response) do
    { status: 200, body: planning_applications_csv, headers: { "Content-Type" => "text/csv"} }
  end

  before do
    create(:local_authority, name: "lambeth")
    stub_request(:get, planning_application_url).to_return(planning_application_response)
  end

  it "imports reference" do
    expect { importer }.to change {
      PlanningApplication.where(reference: "22/02180/POA").exists?
    }.from(false).to(true)
  end

  it "imports area" do
    expect { importer }.to change {
      PlanningApplication.where(area: "Central").exists?
    }.from(false).to(true)
  end

  it "imports proposal_details" do
    expect { importer }.to change {
      PlanningApplication.where(proposal_details: "Submission from Silverstone").exists?
    }.from(false).to(true)
  end

  it "imports received_at" do
    expect { importer }.to change {
      PlanningApplication.where(received_at: "14/06/2022").exists?
    }.from(false).to(true)
  end

  it "imports received_at" do
    expect { importer }.to change {
      PlanningApplication.where(officer_name: "Ms May Lo").exists?
    }.from(false).to(true)
  end

  it "imports decision" do
    expect { importer }.to change {
      PlanningApplication.where(decision: "Discharge - Satisfies Requirements").exists?
    }.from(false).to(true)
  end

  it "imports decision issued at" do
    expect { importer }.to change {
      PlanningApplication.where(decision_issued_at: "02/09/2022").exists?
    }.from(false).to(true)
  end

  it "imports view documents" do
    expect { importer }.to change {
      PlanningApplication.where(view_documents: "https://publicaccess.aylesburyvaledc.gov.uk/online-applications/applicationDetails.do?activeTab=documents&keyVal=AB123").exists?
    }.from(false).to(true)
  end
end
