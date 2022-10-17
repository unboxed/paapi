require "rails_helper"

RSpec.describe PlanningApplicationCreation do
  let(:local_authority) { create(:local_authority, name: "lambeth") }

  let(:planning_application_attrs) do
    { reference: "22/01001/FUL",
    area: "South & East",
    description: "This householder application is for construction of detached garage",
    received_at: "13/06/2022",
    assessor: "Anthony Kwok",
    decision: "Application Refused",
    decision_issued_at: "16/09/2022",
    view_documents: "https://publicaccess.gov.uk/web-url" }
  end

  let(:property_attrs) do
    { uprn: "100081043511",
      property_code: "RD02",
      property_type: "Residential, Dwellings, Detached" }
  end

  let(:address_attrs) do
    { full: nil,
      address: nil,
      town: "London",
      postcode: "SE16 3RQ",
      map_east: "481671",
      map_north: "200897",
      ward_code: "W037",
      ward_name: "Beaconsfield" }
  end

  let(:planning_application_create_attrs) do
    { local_authority: local_authority }.merge(planning_application_attrs).merge(property_attrs).merge(address_attrs)
  end

  let(:planning_application_create) { PlanningApplicationCreation.new(**planning_application_create_attrs).perform }

  it "raises an error when planning application address and full address are blank" do
    expect do
      planning_application_create
    end.to raise_error(PlanningApplicationCreation::PlanningApplicationCreationInvalidProperty, "Planning application reference: 22/01001/FUL has invalid property: Full can't be blank")
  end
end
