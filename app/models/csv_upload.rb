class CsvUpload < ApplicationRecord
  has_many_attached :csv_files
end
