# frozen_string_literal: true

class InsertRowsJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    # Do something later

    DeleteLocalCopyJob.perform_later @csv_upload
    add_message message_text: "Deleting CSV uploads"
  end
end
