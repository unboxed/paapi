# frozen_string_literal: true

require "rails_helper"

RSpec.describe PlanningApplicationCreation do
  let(:local_authority) { create(:local_authority, name: "lambeth") }

  let(:attributes) do
    {
      reference: "22/01001/FUL",
      area: "South & East",
      description: "This householder application is for construction of detached garage",
      received_at: "13/06/2022",
      assessor: "Anthony Kwok",
      decision: "Application Refused",
      decision_issued_at: "16/09/2022",
      view_documents: "https://publicaccess.gov.uk/web-url",
      uprn: "100081043511",
      property_code: "RD02",
      property_type: "Residential, Dwellings, Detached",
      full: nil,
      address: nil,
      town: "London",
      postcode: "SE16 3RQ",
      map_east: "481671",
      map_north: "200897",
      ward_code: "W037",
      ward_name: "Beaconsfield"
    }
  end

  let(:planning_application_create) do
    described_class.new(**attributes).perform
  end

  it "raises an error when planning application address and full address are blank" do
    error = PlanningApplicationCreation::PlanningApplicationCreationInvalidProperty
    message = "Planning application reference: 22/01001/FUL has invalid property: Full can't be blank"

    expect { planning_application_create }.to raise_error(error, message)
  end
end
