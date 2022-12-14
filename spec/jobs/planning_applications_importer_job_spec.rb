# frozen_string_literal: true

require "rails_helper"

RSpec.describe PlanningApplicationsImporterJob do
  let(:planning_application_url) { "https://paapi-staging-import.s3.eu-west-2.amazonaws.com/lambeth/PlanningHistoryLambeth.csv" }
  let(:planning_applications_csv) do
    <<~CSV
      reference, application_type_code, application_type, area, description, received_at, assessor, reviewer, decision, decision_issued_at, validated_at, view_documents, uprn, code, type, address, full, town, postcode, map_east, map_north, latitude, longitude, ward_code, ward_name
      22/02180/POA,FA,Full Application,North & Central,"Submission of details for approval in regards to clauses 11b and c Travel Plan Coordinator, 15b (Membership of Travel Plan Steering Group) and 20b (Membership of Transport Strategy Steering Group) of the Section 106 Agreement attached to Outline Planning Permission 17/01840/AOP Silverstone Circuit",14/06/2022,Mrs Rebecca Jarratt,,Discharge - Satisfies Requirements,02/09/2022,,"https://publicaccess.aylesburyvaledc.gov.uk/online-applications/applicationDetails.do?activeTab=documents&keyVal=AB123",111222333444,RD03,"Residential, Dwellings, Detached",Silverstone Motor Racing Circuit Silverstone Road Biddlesden Buckinghamshire NN12 8TN,Silverstone Motor Racing Circuit Silverstone Road Biddlesden Buckinghamshire NN12 8TN,Towcester,NN12 8TN,467520,241616,,,W037,Ridgeway West
    CSV
  end

  context "when the CSV downloads are successful" do
    before do
      create(:local_authority, name: "lambeth")
      stub_request(:get, planning_application_url).to_return(planning_application_response)
    end

    let(:planning_application_response) do
      { status: 200, body: planning_applications_csv, headers: { "Content-Type" => "text/csv" } }
    end

    it "import creates a PlanningApplication object" do
      expect { importer }.to change(PlanningApplication, :count).by(1)
    end

    it "import local_authority_name is not case sensitive" do
      expect { importer(local_authority_name: "LaMbEth") }.to change(PlanningApplication, :count).by(1)
    end

    it "import only creates the same PlanningApplication once" do
      create(:planning_application, reference: "22/02180/POA")

      expect { importer }.not_to change(PlanningApplication, :count)
    end
  end

  context "when local authority unknown" do
    let(:planning_application_url) { "https://paapi-staging-import.s3.eu-west-2.amazonaws.com/derbyshire/PlanningHistoryDerbyshire.csv" }

    let(:planning_application_response) do
      { status: 200, body: planning_applications_csv, headers: { "Content-Type" => "text/csv" } }
    end

    before do
      stub_request(:get, planning_application_url).to_return(planning_application_response)
    end

    # rubocop:disable RSpec/ExampleLength
    it "returns that local authority couldn't be found" do
      allow(Rails.logger).to receive(:info)

      described_class.perform_now(local_authority_name: "derbyshire")

      expect(ActiveJob::Base.logger)
        .to have_received(:info)
        .with(%(Couldn't find LocalAuthority with [WHERE "local_authorities"."name" = $1]).strip)
        .with(%(Expected S3 filepath: paapi-staging-import/derbyshire/PlanningHistoryDerbyshire.csv).strip)
    end
    # rubocop:enable RSpec/ExampleLength
  end

  context "when filename unknown" do
    let(:planning_application_url) { "https://paapi-staging-import.s3.eu-west-2.amazonaws.com/lambeth/PlanningHistoryLambeth.csv" }

    let(:planning_application_response) do
      { status: 404, body: planning_applications_csv, headers: { "Content-Type" => "text/csv" } }
    end

    before do
      create(:local_authority, name: "lambeth")
      stub_request(:get, planning_application_url).to_return(planning_application_response)
    end

    # rubocop:disable RSpec/ExampleLength
    it "returns that the file is not found" do
      allow(Rails.logger).to receive(:info)

      described_class.perform_now(local_authority_name: "lambeth")

      expect(ActiveJob::Base.logger)
        .to have_received(:info)
        .with(%(Aws::S3::Errors::NotFound).strip)
        .with(%(Expected S3 filepath: paapi-staging-import/lambeth/PlanningHistoryLambeth.csv).strip)
    end
    # rubocop:enable RSpec/ExampleLength
  end

  context "when LOCAL_IMPORT_FILE env var is set to true" do
    let(:planning_applications_importer) do
      described_class.perform_now(local_authority_name: "Lambeth")
    end

    before do
      create(:local_authority, name: "lambeth")
      allow(ENV).to receive(:[]).and_call_original
      allow(ENV).to receive(:[]).with("LOCAL_IMPORT_FILE").and_return("true")

      allow(planning_applications_importer)
        .to receive(:local_import_file)
        .and_return(planning_applications_csv)
    end

    it "imports data from local file" do
      expect { planning_applications_importer }
        .to change(PlanningApplication, :count)
        .by(1)
    end
  end

  def importer(local_authority_name: "lambeth")
    PlanningApplicationsImporterJob.perform_now(local_authority_name:)
  end
end
