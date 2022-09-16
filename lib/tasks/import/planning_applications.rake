namespace :import do
  desc "Import planning applications from S3"
  task planning_applications: :environment do
    broadcast "PlanningApplicationImporter:import\nBegin"
    broadcast "PlanningApplications:#{PlanningApplication.count} " \
              "(Property  #{Property.count}, Address: #{Address.count})"

    ARGV.each { |a| task a.to_sym do ; end }

    begin
      PlanningApplicationsImporter.new(local_authority_name: ARGV[0]).call
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
