# frozen_string_literal: true

require 'bundler/setup'
require 'map_dev_tools'
require 'rspec'
require 'rack/test'

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.before(:each) { ENV['RACK_ENV'] = 'test' }
end
