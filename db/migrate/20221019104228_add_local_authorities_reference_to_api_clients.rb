class AddLocalAuthoritiesReferenceToApiClients < ActiveRecord::Migration[7.0]
  def change
    add_reference :local_authorities, :api_client, index: true
  end
end
