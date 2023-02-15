class DownloadLocalCopyStartJob < ApplicationJob
  def perform(csv_upload)
    @csv_upload = csv_upload
    csv_file_count = csv_upload.csv_files.count
    csv_files_downloaded = 0
    csv_upload.csv_files.each do | csv_file |
      csv_file.download
      csv_files_downloaded += 1
      add_message message_text: "Downloaded #{csv_files_downloaded}/#{csv_file_count} files"
    end

    CheckFormatJob.perform_later @csv_upload
    
    add_message message_text: "Checking format"
  end
end
