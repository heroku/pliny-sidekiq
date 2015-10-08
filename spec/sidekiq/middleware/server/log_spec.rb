require 'spec_helper'

describe Pliny::Sidekiq::Middleware::Server::Log do
  let(:middleware) { described_class.new }

  let(:jid)        { SecureRandom.uuid }
  let(:class_name) { 'Class' }
  let(:job_retry)  { 1 }

  let(:worker)     { double('worker') }
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

  it 'logs the job and retries' do
    expect(middleware).to receive(:count).twice

    expect(Pliny).to receive(:log)
      .with(job: class_name, job_retry: job_retry)
      .once

    call_middleware
  end
end

