class CsvUpload < ApplicationRecord
  has_many_attached :csv_files

  def addMessage message
    @message = message
  end
end
