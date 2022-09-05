# frozen_string_literal: true

require "webmock/rspec"

RSpec.configure do |config|
  config.before(:all) do
    WebMock.disable_net_connect!(
      allow_localhost: true,
      net_http_connect_on_start: true
    )
  end
end
