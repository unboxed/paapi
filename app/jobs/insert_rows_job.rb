# frozen_string_literal: true

class InsertRowsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
  end
end
