class MakeColumnsNullable < ActiveRecord::Migration[7.0]
  def change
    change_column_null(:planning_applications, :proposal_details, true)
    change_column_null(:planning_applications, :received_at, true)
    change_column_null(:planning_applications, :decision, true)

    change_column_null(:addresses, :full, true)
  end
end
