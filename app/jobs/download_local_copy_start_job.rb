class DownloadLocalCopyStartJob < ApplicationJob
  queue_as :low_priority

  def perform(csv_upload)
    @csv_upload = csv_upload
    csv_file_count = csv_upload.csv_files.count
    csv_files_downloaded = 0
    csv_upload.csv_files.each do | csv_file |
      csv_file.download
      csv_files_downloaded += 1
      add_message message_text: "Downloaded #{csv_files_downloaded}/#{csv_file_count}"
    end
  end

  def add_message(message_text:)
    new_message = CsvProcessingMessage.new(
      body: message_text, 
      data: [], 
      csv_upload: @csv_upload
    )
    new_message.save!

    ActionCable.server.broadcast 'message_channel', {message: new_message}
  end
end
