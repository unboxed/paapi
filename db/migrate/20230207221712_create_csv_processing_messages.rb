class CreateCsvProcessingMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :csv_processing_messages do |t|
      t.string :message
      t.jsonb :data
      t.references :csv_upload, null: false, foreign_key: true
      t.timestamps
    end
  end
end
