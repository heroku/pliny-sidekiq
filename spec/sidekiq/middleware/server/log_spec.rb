require 'spec_helper'

describe Pliny::Sidekiq::Middleware::Server::Log do
  let(:middleware) { described_class.new(options) }

  let(:jid)        { SecureRandom.uuid }
  let(:class_name) { 'Class' }
  let(:job_retry)  { 1 }

  let(:options)    { {} }

  let(:worker)     { double('worker', class: class_name) }
  let(:job)        { { 'jid' => jid, 'class' => class_name, 'retry' => job_retry } }
  let(:queue)      { 'queue:default' }

  subject(:call_middleware) { middleware.call(worker, job, queue) { } }

  it 'yields' do
    expect { |b| middleware.call(worker, job, queue, &b) }.to yield_with_no_args
  end

  it 'sets a log context' do
    expect(Pliny).to receive(:context)
      .with(hash_including(sidekiq: true, job_id: jid))
      .once

    call_middleware
  end

  it 'counts worker invocations and queue' do
    expect(middleware).to receive(:count)
      .with(/worker/)
      .once

    expect(middleware).to receive(:count)
      .with(/queue/)
      .once

    call_middleware
  end

  it 'counts with no metric_prefix' do
    allow(Pliny).to receive(:log)

    expect(Pliny).to receive(:log)
      .with(hash_including("count#sidekiq.worker.#{class_name}" => 1))
      .once

    call_middleware
  end

  it 'logs the job and retries' do
    expect(middleware).to receive(:count).twice

    expect(Pliny).to receive(:log)
      .with(job: class_name, job_retry: job_retry)
      .once

    call_middleware
  end

  context "with a metric_prefix" do
    let(:options) { { metric_prefix: 'my-app' } }

    it 'counts with the metric_prefix' do
      allow(Pliny).to receive(:log)

      expect(Pliny).to receive(:log)
        .with(hash_including("count#my-app.sidekiq.worker.#{class_name}" => 1))
        .once

      call_middleware
    end
  end
end

