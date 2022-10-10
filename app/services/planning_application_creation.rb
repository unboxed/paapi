class PlanningApplicationCreation
  class PlanningApplicationCreationInvalidProperty < StandardError; end

  def initialize(**params)
    @local_authority = params.fetch(:local_authority, nil)

    @reference = params.fetch(:reference, nil)
    @area = params.fetch(:area, nil)
    @proposal_details = params.fetch(:proposal_details, nil)
    @received_at = params.fetch(:received_at, nil)
    @officer_name = params.fetch(:officer_name, nil)
    @decision = params.fetch(:decision, nil)
    @decision_issued_at = params.fetch(:decision_issued_at, nil)
    @view_documents = params.fetch(:view_documents, nil)

    @uprn = params.fetch(:uprn, nil)
    @property_code = params.fetch(:property_code, nil)
    @property_type = params.fetch(:property_type, nil)

    @full = params.fetch(:full, nil)
    @address = params.fetch(:address, nil)
    @town = params.fetch(:town, nil)
    @postcode = params.fetch(:postcode, nil)
    @map_east = params.fetch(:map_east, nil)
    @map_north = params.fetch(:map_north, nil)
    @ward_code = params.fetch(:ward_code, nil)
    @ward_name = params.fetch(:ward_name, nil)
  end

  def perform
    importer
  end

  private

  attr_reader :local_authority, :reference, :area, :proposal_details, :received_at, :officer_name, :decision, :decision_issued_at, :view_documents,
              :uprn, :property_code, :property_type,
              :full, :address, :town, :postcode, :map_east, :map_north, :ward_code, :ward_name

  def importer
    with_property do |property|
      PlanningApplication.find_or_initialize_by(reference: reference)
                         .update!(
                           reference: reference,
                           area: area,
                           proposal_details: proposal_details,
                           received_at: received_at,
                           officer_name: officer_name,
                           decision: decision,
                           decision_issued_at: decision_issued_at,
                           view_documents: view_documents,
                           property: property,
                           local_authority: local_authority
                         )
    end
  end

  def with_property
    property = Property.find_by(uprn: uprn)
    unless property
      property = Property.new(uprn: uprn,
                              code: property_code,
                              type: property_type)
      property.build_address(
        full: full.blank? ? address : full,
        town: town,
        ward_code: ward_code,
        ward_name: ward_name,
        postcode: postcode,
        map_east: map_east,
        map_north: map_north
      )

      if property.invalid?
        message = "Planning application reference: #{reference} has invalid property: #{property.address.errors.full_messages.join(",")}"
        raise PlanningApplicationCreationInvalidProperty.new(message)
      end
    end
    yield property
  end
end
