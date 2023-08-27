# frozen_string_literal: true

require "csv"

class CheckFormatJob < ApplicationJob
  def perform(csv_upload)
    @csv_upload = csv_upload
    add_message "Starting Check Format"

    if csv_has_errors?
      add_message "Job stopped - errors in import"
    else
      add_message "No errors - now inserting rows"
      InsertRowsJob.perform_later @csv_upload
    end
  end

  def csv_has_errors?
    results = []
    has_errors = false
    @csv_upload.csv_files.each do |csv_file|
      csv_file.open do |csv_file_info|
        add_message "Checking rows for #{csv_file.filename}"
        csv_results = check_rows(csv_file_info)
        if csv_results[0]
          has_errors = true
        else
          results.push csv_results
        end
      end
    end
    has_errors
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
        add_message "No errors in row #{results.count}", :info
        results.push true
      end

      sleep 0.01
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
