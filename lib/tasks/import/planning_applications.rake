namespace :import do
  desc "Import planning applications from S3"
  task planning_applications: :environment do
    PlanningApplicationsImporter.new.call
  end
end
