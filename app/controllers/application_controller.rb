class ApplicationController < ActionController::API
  before_action :set_default_format, :set_cors_headers

  private

  def set_default_format
    request.format = :json
  end

  def set_cors_headers
    response.set_header("Access-Control-Allow-Origin", "*")
    response.set_header("Access-Control-Allow-Methods", "GET")
    response.set_header(
      "Access-Control-Allow-Headers",
      "Origin, X-Requested-With, Content-Type, Accept"
    )
    response.charset = "utf-8"
  end
end
