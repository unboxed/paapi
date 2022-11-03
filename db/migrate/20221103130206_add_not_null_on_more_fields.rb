class AddNotNullOnMoreFields < ActiveRecord::Migration[7.0]
  def change
    change_column_null :planning_applications, :decision_issued_at, false

    change_column_null :properties, :uprn, false
    change_column_null :properties, :type, false
    change_column_null :properties, :code, false
  end
end
