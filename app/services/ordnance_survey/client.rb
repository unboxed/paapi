# frozen_string_literal: true

module OrdnanceSurvey
  class Client
    HOST = ENV.fetch("OS_DATA_HUB_API_URL", "https://api.os.uk/search/places/v1/").freeze
    TIMEOUT = 5

    def call(uprn)
      faraday.get("uprn?uprn=#{uprn}&output_srs=EPSG:4326&key=#{api_key}") do |request|
        request.options[:timeout] = TIMEOUT
      end
    end

    private

    def faraday
      @faraday ||= Faraday.new(url: HOST) do |f|
        f.response :raise_error
      end
    end

    def api_key
      @api_key ||= ENV.fetch("OS_DATA_HUB_KEY", nil)
    end
  end
end
