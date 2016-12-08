require "spec_helper"

describe Pliny::Sidekiq::Endpoints::Health do
  include Rack::Test::Methods

  def app
    described_class
  end

  describe 'GET /health/sidekiq' do
    before do
      Sidekiq::Worker.clear_all
    end

    it 'reports zero on empty queues' do
      get '/health/sidekiq'
      expect(last_response.status).to eq(200)
      response = MultiJson.decode(last_response.body)
      expect(response['latency']).to be 0
      expect(response['depth']).to be 0
    end
  end
end

