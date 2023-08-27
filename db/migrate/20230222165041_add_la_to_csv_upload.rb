class AddLaToCsvUpload < ActiveRecord::Migration[7.0]
  def change
    add_reference :csv_uploads, :local_authority
  end
end
