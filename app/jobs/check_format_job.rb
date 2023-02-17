# frozen_string_literal: true

class CheckFormatJob < ApplicationJob
  def perform(csv_upload)
    @csv_upload = csv_upload
    (1..7320).each do |i|
      add_message message_text: "Checking format row #{i}/7320", type: :update_last
      sleep(rand(0.1...1.2))
    end
  end
end
