class DownloadLocalCopyStartJob < ApplicationJob
  queue_as :default

  def perform(csv_upload)
    @csv_upload = csv_upload
    csv_file_count = csv_upload.csv_files.count
    csv_files_downloaded = 0
    csv_upload.csv_files.each do | csv_file |
      csv_file.download
      csv_files_downloaded += 1
      add_message message: "Downloaded #{csv_files_downloaded}/#{csv_file_count}"
    end
  end

  def add_message(message:)
    Rails.logger.debug 12333.to_s + message

    msg = CsvProcessingMessage.new(
      body: message, 
      data: [1,2,3], 
      csv_upload: @csv_upload
    ).save!
  end
end
