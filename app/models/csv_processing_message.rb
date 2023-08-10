# frozen_string_literal: true

class CsvProcessingMessage < ApplicationRecord
  belongs_to :csv_upload
  enum message_type: { success: 0, error: 1 }
end
