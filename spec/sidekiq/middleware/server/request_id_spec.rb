require 'spec_helper'

describe Pliny::Sidekiq::Middleware::Server::RequestId do
  let(:store)      { double('store') }
  let(:middleware) { described_class.new(store: store) }

  let(:worker)     { double('worker') }
  let(:job)        { {} }
  let(:queue)      { 'queue:default' }

  subject(:call_middleware) { middleware.call(worker, job, queue) { } }

  before do
    allow(store).to receive(:clear!)
    allow(store).to receive(:seed)
  end

  it 'yields' do
    expect { |b| middleware.call(worker, job, queue, &b) }.to yield_with_no_args
  end

  it 'clears the store' do
    expect(store).to receive(:clear!)
    call_middleware
  end

  context 'with no request id' do
    it 'does not seed with a request id' do
      expect(store).not_to receive(:seed)
      call_middleware
    end
  end

  context 'with a request id' do
    let(:request_id) { SecureRandom.uuid }
    let(:job)        { { 'request_ids' => request_id } }

    it 'seed with a request id' do
      expect(store).to receive(:seed)
        .with(hash_including('REQUEST_IDS' => request_id))
        .once

      call_middleware
    end
  end
end

