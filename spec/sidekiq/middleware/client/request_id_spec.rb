require 'spec_helper'

describe Pliny::Sidekiq::Middleware::Client::RequestId do
  let(:middleware) { described_class.new }

  let(:worker)     { nil }
  let(:args)       { [] }
  let(:msg)        { { 'args' => args } }
  let(:queue)      { 'queue:default' }
  let(:redis_pool) { nil }

  subject(:call_middleware) { middleware.call(worker, msg, queue, redis_pool) { } }

  it 'yields' do
    expect { |b| middleware.call(worker, msg, queue, redis_pool, &b) }
      .to yield_with_no_args
  end

  context 'with no request id in store' do
    before do
      expect(Pliny::RequestStore.store).to receive(:[]).and_return(nil)
    end

    it 'does not seed with a request id' do
      call_middleware
      expect(msg).not_to include('request_ids')
    end
  end

  context 'with a request id in RequestStore' do
    let(:request_id) { SecureRandom.uuid }

    before do
      expect(Pliny::RequestStore.store).to receive(:[]).and_return(request_id)
    end

    it 'is assigned to the message' do
      call_middleware
      expect(msg).to include('request_ids' => [request_id])
    end
  end

  context 'with a request id as args' do
    let(:request_id) { SecureRandom.uuid }
    let(:args) { [{ request_id: request_id }] }

    before do
      allow(Pliny::RequestStore.store).to receive(:[]).and_return(SecureRandom.uuid)
    end

    it 'is assigned to the message' do
      call_middleware
      expect(msg).to include('request_ids' => [request_id])
    end
  end
end
