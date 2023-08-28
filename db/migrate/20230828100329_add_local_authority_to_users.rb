class AddLocalAuthorityToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :local_authority, foreign_key: true
  end
end
