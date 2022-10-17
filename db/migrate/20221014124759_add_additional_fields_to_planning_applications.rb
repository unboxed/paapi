class AddAdditionalFieldsToPlanningApplications < ActiveRecord::Migration[7.0]
  def change
    add_column :planning_applications, :application_type, :string
    add_column :planning_applications, :reviewer, :string
    add_column :planning_applications, :validated_at, :datetime
  end
end
