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

    InsertRowsJob.perform_later @csv_upload
    add_message "Inserting rows"
  end

  def check_rows(file_info)
    results = []
    CSV.foreach(file_info.path, headers: true, header_converters: :symbol) do |row|
      errors = check_row_for_errors(row)

      if errors
        results.push errors
        add_message "Error in row #{results.count}", :error
      else
        add_message "No errors in row #{results.count}"
      end
    end

    file_info.unlink
    results
  end

  def check_row_for_errors(row)
    planning_application = PlanningApplicationCreation.new(
      **row.to_h.merge(local_authority:)
    )
    begin
      planning_application.validate_property
      false
    rescue StandardError
      true
    end
  end

  def local_authority
    @csv_upload.local_authority
  end
end
