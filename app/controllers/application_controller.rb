# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :set_default_format, :set_cors_headers, :set_local_authority, :authenticate_token!

  def authenticate_token!
    payload = JsonWebToken.decode(auth_token)
    ApiClient.find_by!(
      client_name: payload["client_name"],
      client_secret: payload["client_secret"]
    )
  rescue ActiveRecord::RecordNotFound => e
    render json: { errors: e.message }, status: :unauthorized
  rescue JWT::DecodeError
    render json: { errors: "Invalid auth token" }, status: :unauthorized
  end

  def set_local_authority
    payload = JsonWebToken.decode(auth_token)

    @local_authority = LocalAuthority.find_by(name: payload["client_name"])
  end

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

  def auth_token
    @auth_token ||= request.headers.fetch("Authorization", "").split.last
  end
end
