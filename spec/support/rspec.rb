# frozen_string_literal: true

RSpec.configure do |c|
  c.before { allow($stdout).to receive(:puts) }
end
