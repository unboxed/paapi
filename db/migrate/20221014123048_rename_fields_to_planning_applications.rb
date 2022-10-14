class RenameFieldsToPlanningApplications < ActiveRecord::Migration[7.0]
  def change
    rename_column :planning_applications, :proposal_details, :description
    rename_column :planning_applications, :officer_name, :assessor
  end
end
