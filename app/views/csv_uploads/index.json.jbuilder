# frozen_string_literal: true

json.array! @csv_uploads, partial: "csv_uploads/csv_upload", as: :csv_upload
