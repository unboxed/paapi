# frozen_string_literal: true

require "csv"

class CheckFormatJob < ApplicationJob
  def perform(csv_upload)
    @csv_upload = csv_upload
    add_message "Starting CSV Upload"
    csv_upload.csv_files.each do |csv_file|
      csv_file.open do |csv_file_info|
        add_message "Checking rows for #{csv_file.filename}"
        check_rows(csv_file_info)
      end
    end

    #InsertRowsJob.perform_later @csv_upload
    add_message "Job stopped - errors in import"
  end

  def check_rows(file_info)
    results = []
    error_occured = false
    CSV.foreach(file_info.path, headers: true, header_converters: :symbol) do |row|
      error = check_row_for_errors(row)

      if error
        results.push error
        error_occured = true
        add_message "Error in row #{results.count} - #{error}", :error
      else
        add_message "No errors in row #{results.count}"
        results.push true
      end
    end

    file_info.unlink
    [error_occured, results]
  end

  def check_row_for_errors(row)
    planning_application = PlanningApplicationCreation.new(
      **row.to_h.merge(local_authority:)
    )
    begin
      planning_application.validate
      false
    rescue StandardError => e
      e.message
    end
  end

  def local_authority
    @csv_upload.local_authority
  end
end
