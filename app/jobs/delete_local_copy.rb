# frozen_string_literal: true

class DeleteLocalCopyJob < ApplicationJob
  queue_as :low_priority

  def perform(*args)
    # Do something later
  end
end
