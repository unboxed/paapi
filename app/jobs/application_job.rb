# frozen_string_literal: true

class ApplicationJob < ActiveJob::Base
  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  # discard_on ActiveJob::DeserializationError
  queue_as :low_priority

  def add_message(message_text:, type: :update)
    new_message = CsvProcessingMessage.new(
      body: message_text, 
      data: [], 
      csv_upload: @csv_upload
    )
    new_message.save!

    payload = { :body => new_message.body, :id => new_message.id, :type => type }

    ActionCable.server.broadcast "message_channel/csv_uploads/#{@csv_upload.id.to_s}", payload
    ActionCable.server.broadcast "message_channel", payload
  end
end