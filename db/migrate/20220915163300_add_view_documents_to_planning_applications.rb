class AddViewDocumentsToPlanningApplications < ActiveRecord::Migration[7.0]
  def change
    add_column :planning_applications, :view_documents, :string
  end
end
