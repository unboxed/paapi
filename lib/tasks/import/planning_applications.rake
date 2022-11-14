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

  desc "Updating latitude and longitude based on easting and northing coordinates"
  task lat_and_long: :environment do
    broadcast "PlanningApplicationImporter:import:lat_and_long\nBegin"
    broadcast "PlanningApplications:#{PlanningApplication.count} " \
              "(Property  #{Property.count}, Address: #{Address.count})"

    begin
      Address.all.find_each do |address|
        address.longitude, address.latitude = NationalGrid.os_ng_to_wgs84(address.map_east.to_i, address.map_north.to_i)
        address.save
      end
    rescue StandardError => e
      broadcast e.message
    ensure
      broadcast "PlanningApplications:#{PlanningApplication.count} "
      broadcast "End"
    end
  end

  def broadcast(message)
    puts message
    Rails.logger.info message
  end
end
