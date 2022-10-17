class AddApplicationTypeCodeToPlanningApplications < ActiveRecord::Migration[7.0]
  def change
    add_column :planning_applications, :application_type_code, :string
  end
end
