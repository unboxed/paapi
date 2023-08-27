# frozen_string_literal: true

class ApplicationJob < ActiveJob::Base
  discard_on ActiveJob::DeserializationError
  queue_as :low_priority

  def add_message(message_text, type = :success)
    new_message = CsvProcessingMessage.new(
      message_type: type,
      body: message_text,
      data: [],
      csv_upload: @csv_upload
    )
    new_message.save!

    payload = { body: new_message.body, id: new_message.id, type: new_message.message_type,
                created_at: new_message.created_at }

    ActionCable.server.broadcast "message_channel/csv_uploads/#{@csv_upload.id}", payload
    ActionCable.server.broadcast "message_channel", payload
  end
end
