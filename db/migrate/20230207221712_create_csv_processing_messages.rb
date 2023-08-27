class CreateCsvProcessingMessages < ActiveRecord::Migration[7.0]
    def change
      create_table :csv_processing_messages do |t|
        t.string :body
        t.jsonb :data
        t.integer :message_type, default: 0
        t.references :csv_upload, null: false
      end
    end
  end