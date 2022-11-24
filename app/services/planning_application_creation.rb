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
    latitude
    longitude
    postcode
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
    validate_property

    PlanningApplication
      .find_or_initialize_by(reference:)
      .update!(**planning_application_attributes)
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
      local_authority:,
      property:
    }
  end

  def property
    @property ||= Property.find_by(uprn:) || Property.new(
      uprn:,
      code:,
      type:,
      address: new_address
    )
  end

  def new_address
    @new_address ||= Address.new(
      full: full.presence || address,
      town:,
      ward_code:,
      ward_name:,
      postcode:,
      map_east:,
      map_north:,
      latitude:,
      longitude:
    )
  end

  def validate_property
    return if property.valid?

    errors = new_address.errors.full_messages.join(",")
    message = "Planning application reference: #{reference} has invalid property: #{errors}"
    raise PlanningApplicationCreationInvalidProperty, message
  end
end
