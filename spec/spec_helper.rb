# make sure this is set before Sinatra is required
ENV["RACK_ENV"] = "test"

require "bundler"
Bundler.require

require "pliny"
require "sidekiq"
require "sidekiq/testing"
require "rack/test"
# require "timecop"

require_relative "../lib/pliny/sidekiq"

Sidekiq::Testing.fake!

RSpec.configure do |config|
  config.include Rack::Test::Methods

  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.before :each do
    Pliny::RequestStore.clear!
  end

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'
end

Pliny.stdout = StringIO.new
