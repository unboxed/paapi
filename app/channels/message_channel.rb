class MessageChannel < ApplicationCable::Channel
  def subscribed

    subscription_string = 'message_channel' + ((params.key? 'path') ? (params['path']) : '')
    stream_from subscription_string
    Rails.logger.info('Set stream_from to ' + subscription_string)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def receive(data)
  end
end
