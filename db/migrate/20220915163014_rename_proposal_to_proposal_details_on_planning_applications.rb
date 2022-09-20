class RenameProposalToProposalDetailsOnPlanningApplications < ActiveRecord::Migration[7.0]
  def change
    rename_column :planning_applications, :proposal_details, :proposal_details
  end
end
