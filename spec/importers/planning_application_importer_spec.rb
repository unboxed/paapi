require "rails_helper"

RSpec.describe "PlanningApplicationsImporter - PlanningApplication" do

  let(:planning_application_url) { "https://paapi-staging-import.s3.eu-west-2.amazonaws.com/lambeth/PlanningHistoryLambeth.csv" }
  let(:planning_applications_csv) do
    <<-CSV.strip_heredoc
      area, uprn, reference, address, proposal_details, received_at, officer_name, decision, decision_issued_at, map_east, map_north, full, postcode, town, view_documents
      Central,766298059,22/02180/POA,1 Silverstone Road NN12 8TN,"Submission from Silverstone",14/06/2022,Ms May Lo,Discharge - Satisfies Requirements,02/09/2022,467520,241616,Silverstone Silverstone Road Biddlesden Buckinghamshire NN12 8TN,NN12 8TN,Towcester,"https://publicaccess.aylesburyvaledc.gov.uk/online-applications/applicationDetails.do?activeTab=documents&keyVal=AB123"
    CSV
  end

  context "when the CSV downloads are successful" do
    before do
      create(:local_authority, name: "lambeth")
      stub_request(:get, planning_application_url).to_return(planning_application_response)
    end

    let(:planning_application_response) do
      { status: 200, body: planning_applications_csv, headers: { "Content-Type" => "text/csv"} }
    end

    it "import creates a PlanningApplication object" do
      expect { importer }.to change { PlanningApplication.count }.by(1)
    end

    it "import local_authority_name is not case sensitive" do
      expect { importer(local_authority_name: "LaMbEth") }.to change { PlanningApplication.count }.by(1)
    end

    it "import only creates the same PlanningApplication once" do
      create(:planning_application, reference: "22/02180/POA")

      expect { importer }.to change { PlanningApplication.count }.by(0)
    end
  end

  context "when local authority unknown" do
    let(:planning_application_url) { "https://paapi-staging-import.s3.eu-west-2.amazonaws.com/derbyshire/PlanningHistoryDerbyshire.csv" }

    let(:planning_application_response) do
      { status: 200, body: planning_applications_csv, headers: { "Content-Type" => "text/csv"} }
    end

    before do
      stub_request(:get, planning_application_url).to_return(planning_application_response)
    end

    it "returns that local authority couldn't be found" do
      allow(Rails.logger).to receive(:info)

      expect(ActiveJob::Base.logger).to receive(:info)
        .with(%[Couldn't find LocalAuthority with [WHERE "local_authorities"."name" = $1]].strip)

      PlanningApplicationsImporter.new(local_authority_name: "derbyshire").call
    end
  end

  context "when filename unknown" do
    let(:planning_application_url) { "https://paapi-staging-import.s3.eu-west-2.amazonaws.com/lambeth/PlanningHistoryLambeth.csv" }

    let(:planning_application_response) do
      { status: 404, body: planning_applications_csv, headers: { "Content-Type" => "text/csv"} }
    end

    before do
      create(:local_authority, name: "lambeth")
      stub_request(:get, planning_application_url).to_return(planning_application_response)
    end

    it "returns that the file is not found" do
      allow(Rails.logger).to receive(:info)

      expect(ActiveJob::Base.logger).to receive(:info)
        .with(%[Aws::S3::Errors::NotFound].strip)

      PlanningApplicationsImporter.new(local_authority_name: "lambeth").call
    end
  end

  def importer(local_authority_name: "lambeth")
    PlanningApplicationsImporter.new(local_authority_name: local_authority_name).call
  end
end
