module Pliny::Sidekiq::Middleware
  module Server
    class Log
      def initialize(metric_prefix: nil)
        @metric_prefix = metric_prefix
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
        Pliny.log("count##{metric_prefix}sidekiq.#{key}" => value)
      end

      def metric_prefix
        @metric_prefix.nil? ? '' : "#{@metric_prefix}."
      end
    end
  end
end
