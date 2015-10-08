module Pliny::Sidekiq::Middleware
  module Client
    class Log
      def call(worker_class, msg, queue, redis_pool)
        yield.tap do
          data = {
            job:      msg['class'],
            job_id:   msg['jid'],
            enqueued: true
          }
          data[:enqueued_at] = Time.at(msg['enqueued_at']) if msg.has_key?('enqueued_at')

          Pliny.log(data)
        end
      end
    end
  end
end
