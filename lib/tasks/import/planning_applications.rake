# frozen_string_literal: true

namespace :import do
  desc "Import planning applications from S3"
  task planning_applications: :environment do
    abort("Please provide LOCAL_AUTHORITY") if ENV["LOCAL_AUTHORITY"].blank?
    broadcast "PlanningApplicationImporter:import:planning_applications\nBegin"
    broadcast "PlanningApplications:#{PlanningApplication.count} " \
              "(Property  #{Property.count}, Address: #{Address.count})"

    begin
      PlanningApplicationsImporter.new(local_authority_name: ENV["LOCAL_AUTHORITY"].to_sym).call
    rescue StandardError => e
      broadcast e.message
    ensure
      broadcast "PlanningApplications:#{PlanningApplication.count} " \
                "(Property  #{Property.count}, Address: #{Address.count})"
      broadcast "End"
    end
  end

  desc "Set latitude and longitude using OS Data Hub"
  task lat_and_long: :environment do
    broadcast "PlanningApplicationImporter:import:lat_and_long\nBegin"
    broadcast "PlanningApplications:#{PlanningApplication.count} " \
              "(Property  #{Property.count}, Address: #{Address.count})"

    begin
      addresses = []

      Address.all.find_each do |address|
        uprn_place = OrdnanceSurvey::Query.new.fetch(address.property.uprn)

        if uprn_place.nil?
          addresses << address.property.uprn
        else
          address.update!(
            latitude: uprn_place.first["DPA"]["LAT"],
            longitude: uprn_place.first["DPA"]["LNG"]
          )
        end
      end
    rescue StandardError => e
      broadcast e.message
    ensure
      broadcast "PlanningApplications:#{PlanningApplication.count} " \
                "(Address not changed: #{addresses.count})"
      broadcast "End"
    end
  end

  def broadcast(message)
    puts message
    Rails.logger.info message
  end
end
