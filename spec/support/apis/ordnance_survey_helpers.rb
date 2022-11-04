# frozen_string_literal: true

module OrdnanceSurveyHelper
  BASE_URL = "https://api.os.uk/search/places/v1"
  API_KEY = "1Gb6eQu6kyqrLH9ACNorINhTJBeBAlZh"

  def stub_ordnance_survey_api_request_for(uprn)
    stub_request(:get, "#{BASE_URL}/uprn?uprn=#{uprn}&output_srs=EPSG:4326&key=#{API_KEY}")
  end

  def ordnance_survey_api_response(status, body = "200010019924")
    status = Rack::Utils.status_code(status)

    body = if body == "no_result"
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

    config.before do
      stub_ordnance_survey_api_request_for("200010019924").to_return(ordnance_survey_api_response(:ok))
      stub_ordnance_survey_api_request_for("20001001992").to_return(ordnance_survey_api_response(:not_found,
                                                                                                 "no_result"))
    end
  end
end
