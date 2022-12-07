class AddUniqueIndexBetweenReferenceAddLocalAuthorityId < ActiveRecord::Migration[7.0]
  def change
    add_index :planning_applications, %i[reference local_authority_id], unique: true
  end
end
