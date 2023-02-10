class MessageChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.info('Subscribed')
    stream_from "message_channel"
    Rails.logger.info('Set stream_from message_channel')
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def receive(data)
  end
end
