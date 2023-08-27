# frozen_string_literal: true

require "csv"

class InsertRowsJob < ApplicationJob
  def perform(csv_upload)
    @csv_upload = csv_upload
    add_message "Starting Insert Rows"

    insert_from_all_files
  end

  def insert_from_all_files
    results = []
    has_errors = false
    @csv_upload.csv_files.each do |csv_file|
      csv_file.open do |csv_file_info|
        add_message "Inserting rows for #{csv_file.filename}"
        insert_rows(csv_file_info)
      end
    end

    add_message "Completed adding rows"
  end

  def insert_rows(file_info)
    results = []
    CSV.foreach(file_info.path, headers: true, header_converters: :symbol) do |row|
      insert_row(row)
      results.push true
      add_message "Inserted row #{results.count}", :info 
      sleep 0.01
    end

    file_info.unlink
  end

  def insert_row(row)
    planning_app_creation = PlanningApplicationCreation.new(
      **row.to_h.merge(local_authority:)
    ).perform
  end

  def local_authority
    @csv_upload.local_authority
  end
end
