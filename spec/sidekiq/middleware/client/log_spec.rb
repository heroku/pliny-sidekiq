require 'spec_helper'

describe Pliny::Sidekiq::Middleware::Client::Log do
  let(:middleware)  { described_class.new }

  let(:jid)         { SecureRandom.uuid }
  let(:class_name)  { 'Class' }
  let(:enqueued_at) { 0 }

  let(:worker)      { nil }
  let(:queue)       { 'queue:default' }
  let(:redis_pool)  { nil }

  let(:msg) do
    {
      'class' => class_name,
      'jid' => jid,
      'enqueued_at' => enqueued_at
    }
  end

  subject(:call_middleware) { middleware.call(worker, msg, queue, redis_pool) { } }

  it 'yields' do
    expect { |b| middleware.call(worker, msg, queue, redis_pool, &b) }
      .to yield_with_no_args
  end

  it 'logs' do
    expect(Pliny).to receive(:log)
      .with(hash_including(
        job:         class_name,
        job_id:      jid,
        enqueued_at: Time.at(enqueued_at)
       ))
      .once

    call_middleware
  end

  context "with enqueued_at missing" do
    let(:msg) do
      {
        'class' => class_name,
        'jid' => jid
      }
    end

    it 'logs' do
      expect(Pliny).to receive(:log)
        .with(hash_including(
          job:    class_name,
          job_id: jid
        ))
        .once

      call_middleware
    end
  end
end

