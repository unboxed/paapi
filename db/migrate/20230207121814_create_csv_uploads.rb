class CreateCsvUploads < ActiveRecord::Migration[7.0]
    def change
      create_table :csv_uploads do |t|
        t.string :title

        t.timestamps
      end
    end
  end
