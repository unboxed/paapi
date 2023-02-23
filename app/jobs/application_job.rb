# frozen_string_literal: true

class ApplicationJob < ActiveJob::Base
  queue_as :low_priority

  def add_message(message_text, type = :success)
    new_message = CsvProcessingMessage.new(
      message_type: type,
      body: message_text,
      data: [],
      csv_upload: @csv_upload
    )
    new_message.save!
  end
end
