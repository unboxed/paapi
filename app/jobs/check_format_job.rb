class CheckFormatJob < ApplicationJob
  queue_as :default

  def perform(csv)
    # Do something later
  end
end
