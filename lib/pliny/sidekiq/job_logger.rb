module Pliny::Sidekiq
  class JobLogger
    def prepare(job)
      yield
    end

    def call(job, queue)
      context = {
        sidekiq: true,
        job:     job['class'],
        job_id:  job['jid'],
        job_retry: job['retry'],
      }

      begin
        start = ::Process.clock_gettime(::Process::CLOCK_MONOTONIC)
        log(context, job_logger: true, at: :start)
        yield
        log(context, job_logger: true, at: :finish, status: :done, duration: elapsed(start))
      rescue Exception
        log(context, job_logger: true, at: :finish, status: :fail, duration: elapsed(start))
        raise
      end
    end

    private

    def log(context, data = {}, &blk)
      Pliny.log(context.merge(data), &blk)
    end

    def elapsed(start)
      (::Process.clock_gettime(::Process::CLOCK_MONOTONIC) - start).round(3)
    end
  end
end
