# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read(".ruby-version").strip.split("-").last

gem "dotenv-rails", require: "dotenv/rails-now"

gem "appsignal"
gem "aws-sdk-s3"
gem "bootsnap", require: false
gem "cssbundling-rails"
gem "dartsass-rails"
gem "jbuilder"
gem "jsbundling-rails"
gem "jwt"
gem "pg", "~> 1.4"
gem "puma", "~> 6.0"
gem "rails", "~> 7.0.6"
gem "rswag-ui"
gem "sidekiq"
gem "sprockets-rails"
gem "stimulus-rails"
gem "turbo-rails"
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem "brakeman", require: false
  gem "bundler-audit", require: false
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "factory_bot_rails"
  gem "faker"
  gem "jekyll", require: false
  gem "pry-byebug"
  gem "rspec-rails", "~> 6.0"
  gem "rubocop", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
end

group :test do
  gem "webmock"
end
