# frozen_string_literal: true

class CsvProcessingMessage < ApplicationRecord
  belongs_to :csv_upload
  enum message_type: { info: 0, success: 1, error: 2 }
end
