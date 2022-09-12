require "rails_helper"

RSpec.describe "PlanningApplicationsImporter - address" do
  let(:planning_application_url) { "https://paapi-staging-import.s3.eu-west-2.amazonaws.com/PlanningHistoryBucks.csv" }

  context "when the CSV downloads are successful" do
    let(:planning_applications_csv) do
      <<-CSV.strip_heredoc
        area, uprn, reference, address, proposal, received_at, officer_name, decision, decision_issued_at, map_east, map_north, full, postcode, town
        North & Central,766298059,22/02180/POA,Silverstone Motor Racing Circuit Silverstone Road Biddlesden Buckinghamshire NN12 8TN,"Submission of details for approval in regards to clauses 11b and c Travel Plan Coordinator, 15b (Membership of Travel Plan Steering Group) and 20b (Membership of Transport Strategy Steering Group) of the Section 106 Agreement attached to Outline Planning Permission 17/01840/AOP Silverstone Circuit",14/06/2022,Mrs Rebecca Jarratt,Discharge - Satisfies Requirements,02/09/2022,467520,241616,Silverstone Motor Racing Circuit Silverstone Road Biddlesden Buckinghamshire NN12 8TN,NN12 8TN,Towcester
      CSV
    end

    before do
      stub_request(:get, planning_application_url).to_return(planning_application_response)
    end

    let(:planning_application_response) do
      { status: 200, body: planning_applications_csv, headers: { "Content-Type" => "text/csv"} }
    end

    it "import creates an Address object from CSV data" do
      expect { PlanningApplicationsImporter.new.call }.to change { Address.count }.by(1)
    end

    it "imports full address" do
      expect { PlanningApplicationsImporter.new.call }.to change {
        Address.where(full: "Silverstone Motor Racing Circuit Silverstone Road Biddlesden Buckinghamshire NN12 8TN").exists?
      }.from(false).to(true)
    end

    it "imports postcode" do
      expect { PlanningApplicationsImporter.new.call }.to change {
        Address.where(postcode: "NN12 8TN").exists?
      }.from(false).to(true)
    end

    it "imports town" do
      expect { PlanningApplicationsImporter.new.call }.to change {
        Address.where(town: "Towcester").exists?
      }.from(false).to(true)
    end

    it "imports map_east" do
      expect { PlanningApplicationsImporter.new.call }.to change {
        Address.where(map_east: "467520").exists?
      }.from(false).to(true)
    end

    it "imports map_north" do
      expect { PlanningApplicationsImporter.new.call }.to change {
        Address.where(map_north: "241616").exists?
      }.from(false).to(true)
    end
  end

  context "when full address is blank" do
    let(:planning_applications_without_full_address_csv) do
      <<-CSV.strip_heredoc
        area, uprn, reference, address, proposal, received_at, officer_name, decision, decision_issued_at, map_east, map_north, full, postcode, town
        West,766303499,22/06867/PNP6A,Rockwell House Rockwell Lane Buckinghamshire RG9 6NF,"Prior approval application (Part 6, Class A) for construction of agricultural building for storage of hay, concentrate feed, bedding and machinery",2022-07-08T00:00:00,Victoria Burdett,Details Not Required to be Submitted,2022-08-05T00:00:00,479625,188169,             ,RG9 6NF,Henley
      CSV
    end

    let(:planning_application_response) do
      { status: 200, body: planning_applications_without_full_address_csv, headers: { "Content-Type" => "text/csv"} }
    end

    before do
      stub_request(:get, planning_application_url).to_return(planning_application_response)
    end

    it "imports full address from planning application address" do
      expect { PlanningApplicationsImporter.new.call }.to change {
        Address.where(full: "Rockwell House Rockwell Lane Buckinghamshire RG9 6NF").exists?
      }.from(false).to(true)
    end
  end

  context "when planning application address and full address are blank" do
    let(:planning_applications_invalid_address_csv) do
      <<-CSV.strip_heredoc
        area, uprn, reference, address, proposal, received_at, officer_name, decision, decision_issued_at, map_east, map_north, full, postcode, town
        West,766303499,22/06867/PNP6A,,"Prior approval application (Part 6, Class A) for construction of agricultural building for storage of hay, concentrate feed, bedding and machinery",2022-07-08T00:00:00,Victoria Burdett,Details Not Required to be Submitted,2022-08-05T00:00:00,479625,188169,,RG9 6NF,Henley
      CSV
    end

    let(:planning_application_response) do
      { status: 200, body: planning_applications_invalid_address_csv, headers: { "Content-Type" => "text/csv"} }
    end

    before do
      stub_request(:get, planning_application_url).to_return(planning_application_response)
    end

    it "logs the invalid row" do
      allow(Rails.logger).to receive(:info)

      expect(ActiveJob::Base.logger).to receive(:info)
        .with(%[Planning application reference: 22/06867/PNP6A has invalid property: Full can't be blank].strip)

      PlanningApplicationsImporter.new.call
    end
  end
end
