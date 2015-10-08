module Pliny::Sidekiq::Middleware
  module Client
    class Log
      def call(worker_class, msg, queue, redis_pool)
        yield.tap do
          Pliny.log(
            job:         msg['class'],
            job_id:      msg['jid'],
            enqueued:    true,
            enqueued_at: Time.at(msg['enqueued_at'])
          )
        end
      end
    end
  end
end
