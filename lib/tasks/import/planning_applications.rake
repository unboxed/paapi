namespace :import do
  desc "Import planning applications from S3"
  task planning_applications: :environment do
    abort("Please provide LOCAL_AUTHORITY") if ENV["LOCAL_AUTHORITY"].blank?
    broadcast "PlanningApplicationImporter:import\nBegin"
    broadcast "PlanningApplications:#{PlanningApplication.count} " \
              "(Property  #{Property.count}, Address: #{Address.count})"

    begin
      PlanningApplicationsImporter.new(local_authority_name: ENV["LOCAL_AUTHORITY"].to_sym).call
    rescue => error
      broadcast error.message
    ensure
      broadcast "PlanningApplications:#{PlanningApplication.count} " \
                "(Property  #{Property.count}, Address: #{Address.count})"
      broadcast "End"
    end
  end

  def broadcast(message)
    puts message
    Rails.logger.info message
  end
end
