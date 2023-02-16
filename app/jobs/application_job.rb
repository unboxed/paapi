# frozen_string_literal: true

class ApplicationJob < ActiveJob::Base
  queue_as :low_priority

  def add_message(message_text:, type: :update)
    new_message = CsvProcessingMessage.new(
      body: message_text, 
      data: [], 
      csv_upload: @csv_upload
    )
    new_message.save!

    payload = { :body => new_message.body, :id => new_message.id, :type => type, :created_at => new_message.created_at }

    ActionCable.server.broadcast "message_channel/csv_uploads/#{@csv_upload.id.to_s}", payload
    ActionCable.server.broadcast "message_channel", payload
  end
end