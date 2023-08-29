class AddTimestampsToCsvProcessingMessages < ActiveRecord::Migration[7.0]
    def change
      add_column :csv_processing_messages, :created_at, :datetime
      add_index :csv_processing_messages, :created_at
      add_column :csv_processing_messages, :updated_at, :datetime
      add_index :csv_processing_messages, :updated_at
    end
  end