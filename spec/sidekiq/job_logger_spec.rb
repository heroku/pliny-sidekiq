require 'spec_helper'

describe Pliny::Sidekiq::JobLogger do
  let(:job_logger) { described_class.new }

  let(:jid)        { SecureRandom.uuid }
  let(:class_name) { 'TestClass' }
  let(:job_retry)  { 1 }

  let(:job)        { { 'jid' => jid, 'class' => class_name, 'retry' => job_retry } }
  let(:queue)      { 'queue:default' }

  it 'yields' do
    expect { |b| job_logger.call(job, queue, &b) }.to yield_with_no_args
  end

  it 'logs the job start and finish without errors' do
    expect(Pliny).to receive(:log)
      .with(
        hash_including(
          sidekiq: true,
          job: class_name,
          job_id: jid,
          job_retry: job_retry,
          job_logger: true,
          at: :start
        )
      )
      .once

    expect(Pliny).to receive(:log)
      .with(
        hash_including(
          sidekiq: true,
          job: class_name,
          job_id: jid,
          job_retry: job_retry,
          job_logger: true,
          at: :finish,
          status: :done,
        )
      )
      .once

    job_logger.call(job, queue) { }
  end

  it 'logs the job start and finis with errors' do
    expect(Pliny).to receive(:log)
      .with(
        hash_including(
          sidekiq: true,
          job: class_name,
          job_id: jid,
          job_retry: job_retry,
          job_logger: true,
          at: :start
        )
      )
      .once

    expect(Pliny).to receive(:log)
      .with(
        hash_including(
          sidekiq: true,
          job: class_name,
          job_id: jid,
          job_retry: job_retry,
          job_logger: true,
          at: :finish,
          status: :fail,
        )
      )
      .once

    expect do
      job_logger.call(job, queue) { raise StandardError }
    end.to raise_error(StandardError)
  end
end
