# frozen_string_literal: true

class CsvUpload < ApplicationRecord
  has_many_attached :csv_files
  has_many :csv_processing_messages, dependent: :destroy
  belongs_to :local_authority, optional: true

  def filtered_csv_processing_messages
    success_message = csv_processing_messages
                      .where(message_type: 0)
                      .order(created_at: :desc)
                      .first

    error_messages = csv_processing_messages
                     .where(message_type: [1, 2])
                     .order(created_at: :asc)

    if success_message.present?
      error_messages.or(
        CsvProcessingMessage.where(id: success_message.id)
      )
    else
      error_messages
    end
  end
end
