# frozen_string_literal: true

module OrdnanceSurvey
  class Query
    def fetch(uprn)
      response = client.call(uprn)

      if response.success?
        parse(JSON.parse(response.body))
      else
        []
      end
    rescue Faraday::ResourceNotFound, Faraday::ClientError
      []
    rescue Faraday::Error => e
      Appsignal.send_exception(e)
      []
    end

    private

    def parse(body)
      body["results"]
    end

    def client
      @client ||= OrdnanceSurvey::Client.new
    end
  end
end
