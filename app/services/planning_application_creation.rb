# frozen_string_literal: true

class PlanningApplicationCreation
  class PlanningApplicationCreationInvalidProperty < StandardError; end

  ATTRIBUTES = %i[
    address
    application_type
    application_type_code
    area
    assessor
    code
    decision
    decision_issued_at
    description
    full
    local_authority
    map_east
    map_north
    postcode
    property_code
    property_type
    received_at
    reference
    reviewer
    town
    type
    uprn
    validated_at
    view_documents
    ward_code
    ward_name
  ].freeze

  def initialize(**params)
    ATTRIBUTES.each do |attribute|
      instance_variable_set("@#{attribute}", params.fetch(attribute, nil))
    end
  end

  def perform
    importer
  end

  private

  attr_reader(*ATTRIBUTES)

  def importer
    with_property do |property|
      PlanningApplication
        .find_or_initialize_by(reference:)
        .update!(
          **planning_application_attributes,
          property:
        )
    end
  end

  def planning_application_attributes
    {
      application_type:,
      application_type_code:,
      reviewer:,
      validated_at:,
      reference:,
      area:,
      description:,
      received_at:,
      assessor:,
      decision:,
      decision_issued_at:,
      view_documents:,
      local_authority:
    }
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def with_property
    property = Property.find_by(uprn:)
    unless property
      property = Property.new(
        uprn:,
        code: code.presence || property_code,
        type: type.presence || property_type
      )

      property.build_address(
        full: full.presence || address,
        town:,
        ward_code:,
        ward_name:,
        postcode:,
        map_east:,
        map_north:
      )

      if property.invalid?
        errors = property.address.errors.full_messages.join(",")
        message = "Planning application reference: #{reference} has invalid property: #{errors}"
        raise PlanningApplicationCreationInvalidProperty, message
      end
    end
    yield property
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize
end
