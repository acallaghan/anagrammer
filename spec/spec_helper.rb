require 'rspec-benchmark'
require 'rack/test'
require_relative '../server'

ENV['RACK_ENV'] = 'test'

module RSpecSinatraMixin
  include Rack::Test::Methods
  def app
    Sinatra::Application
  end
end

RSpec.configure do |config|
  config.include RSpec::Benchmark::Matchers, type: :benchmark
  config.include RSpecSinatraMixin, type: :request

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
