class CsvUpload < ApplicationRecord
  has_many_attached :csv_files
  has_many :csv_processing_messages, dependent: :destroy
end
