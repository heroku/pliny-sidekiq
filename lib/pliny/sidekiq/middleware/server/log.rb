module Pliny::Sidekiq::Middleware
  module Server
    class Log
      def initialize(_opts={})
      end

      def call(worker, job, queue)
        context = {
          sidekiq: true,
          job:     job['class'],
          job_id:  job['jid'],
        }

        Pliny.context(context) do
          count("worker.#{worker.class.to_s.gsub('::', '.')}")
          count("queue.#{queue}")

          Pliny.log(job: job['class'], job_retry: job['retry']) do
            yield
          end
        end
      end

      private

      def count(key, value=1)
        Pliny::Metrics.count("sidekiq.#{key}", value)
      end
    end
  end
end
