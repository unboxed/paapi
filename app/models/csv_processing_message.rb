require 'action_cable'
class CsvProcessingMessage < ApplicationRecord
  belongs_to :csv_upload
end
