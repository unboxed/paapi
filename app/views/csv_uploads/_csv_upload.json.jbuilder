json.extract! csv_upload, :id, :title, :created_at, :updated_at
json.url csv_upload_url(csv_upload, format: :json)
