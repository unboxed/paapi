require "rails_helper"

RSpec.describe "PlanningApplicationsImporter - PlanningApplication" do

  let(:planning_application_url) { "https://paapi-staging-import.s3.eu-west-2.amazonaws.com/PlanningHistoryBucks.csv" }
  let(:planning_applications_csv) do
    <<-CSV.strip_heredoc
      area, uprn, reference, address, proposal, received_at, officer_name, decision, decision_issued_at, map_east, map_north, full, postcode, town
      Central,766298059,22/02180/POA,1 Silverstone Road NN12 8TN,"Submission from Silverstone",14/06/2022,Ms May Lo,Discharge - Satisfies Requirements,02/09/2022,467520,241616,Silverstone Silverstone Road Biddlesden Buckinghamshire NN12 8TN,NN12 8TN,Towcester
    CSV
  end

  before do
    stub_request(:get, planning_application_url).to_return(planning_application_response)
  end

  context "when the CSV downloads are successful" do
    let(:planning_application_response) do
      { status: 200, body: planning_applications_csv, headers: { "Content-Type" => "text/csv"} }
    end

    it "import creates a PlanningApplication object" do
      expect { PlanningApplicationsImporter.new.call }.to change { PlanningApplication.count }.by(1)
    end

    it "import only creates the same PlanningApplication once" do
      create(:planning_application, reference: "22/02180/POA")

      expect { PlanningApplicationsImporter.new.call }.to change { PlanningApplication.count }.by(0)
    end

    describe "attributes" do
      it "imports reference" do
        expect { PlanningApplicationsImporter.new.call }.to change {
          PlanningApplication.where(reference: "22/02180/POA").exists?
        }.from(false).to(true)
      end

      it "imports area" do
        expect { PlanningApplicationsImporter.new.call }.to change {
          PlanningApplication.where(area: "Central").exists?
        }.from(false).to(true)
      end

      it "imports proposal" do
        expect { PlanningApplicationsImporter.new.call }.to change {
          PlanningApplication.where(proposal: "Submission from Silverstone").exists?
        }.from(false).to(true)
      end

      it "imports received_at" do
        expect { PlanningApplicationsImporter.new.call }.to change {
          PlanningApplication.where(received_at: "14/06/2022").exists?
        }.from(false).to(true)
      end

      it "imports received_at" do
        expect { PlanningApplicationsImporter.new.call }.to change {
          PlanningApplication.where(officer_name: "Ms May Lo").exists?
        }.from(false).to(true)
      end

      it "imports decision" do
        expect { PlanningApplicationsImporter.new.call }.to change {
          PlanningApplication.where(decision: "Discharge - Satisfies Requirements").exists?
        }.from(false).to(true)
      end

      it "imports decision issued at" do
        expect { PlanningApplicationsImporter.new.call }.to change {
          PlanningApplication.where(decision_issued_at: "02/09/2022").exists?
        }.from(false).to(true)
      end
    end
  end
end