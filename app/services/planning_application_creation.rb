# frozen_string_literal: true

class PlanningApplicationCreation
  class PlanningApplicationCreationInvalidProperty < StandardError; end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def initialize(**params)
    @local_authority = params.fetch(:local_authority, nil)

    @reference = params.fetch(:reference, nil)
    @area = params.fetch(:area, nil)
    @description = params.fetch(:description, nil)
    @received_at = params.fetch(:received_at, nil)
    @assessor = params.fetch(:assessor, nil)
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
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  def perform
    importer
  end

  private

  attr_reader :local_authority,
              :reference,
              :area,
              :description,
              :received_at,
              :assessor,
              :decision,
              :decision_issued_at,
              :view_documents,
              :uprn,
              :property_code,
              :property_type,
              :full,
              :address,
              :town,
              :postcode,
              :map_east,
              :map_north,
              :ward_code,
              :ward_name

  # rubocop:disable Metrics/MethodLength
  def importer
    with_property do |property|
      PlanningApplication
        .find_or_initialize_by(reference:)
        .update!(
          reference:,
          area:,
          description:,
          received_at:,
          assessor:,
          decision:,
          decision_issued_at:,
          view_documents:,
          property:,
          local_authority:
        )
    end
  end
  # rubocop:enable Metrics/MethodLength

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def with_property
    property = Property.find_by(uprn:)
    unless property
      property = Property.new(
        uprn:,
        code: property_code,
        type: property_type
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
