class DropNullDecisionAssuedAtToPlanningApplications < ActiveRecord::Migration[7.0]
  def change
    change_column_null :planning_applications, :decision_issued_at, true
  end
end
