module Pliny::Sidekiq::Middleware
  module Server
    class Log
      def call(worker, job, queue)
        context = {
          sidekiq: true,
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

      def count(key, value=1)
        Pliny.log("count#kolkrabbi.sidekiq.#{key}" => value)
      end
    end
  end
end
