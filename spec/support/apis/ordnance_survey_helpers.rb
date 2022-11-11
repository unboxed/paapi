# frozen_string_literal: true

module OrdnanceSurveyHelper
  BASE_URL = "https://api.os.uk/search/places/v1"
  API_KEY = "key"

  def stub_ordnance_survey_api_request_for(uprn)
    stub_request(:get, "#{BASE_URL}/uprn?uprn=#{uprn}&output_srs=EPSG:4326&key=#{API_KEY}")
  end

  def stub_ordnance_survey_api_request
    stub_request(:get, /#{BASE_URL}.*/o)
  end

  def ordnance_survey_api_response(status, body = "200010019924", &block)
    status = Rack::Utils.status_code(status)

    body = if block
             yield
           elsif body == "no_result"
             []
           else
             File.read(Rails.root.join("spec", "fixtures", "ordnance_survey", "#{body}.json"))
           end

    { status:, body: }
  end
end

if RSpec.respond_to?(:configure)
  RSpec.configure do |config|
    config.include(OrdnanceSurveyHelper)
    ENV["OS_DATA_HUB_KEY"] = OrdnanceSurveyHelper::API_KEY

    config.before do
      stub_ordnance_survey_api_request.to_return(ordnance_survey_api_response(:ok))
    end
  end
end
