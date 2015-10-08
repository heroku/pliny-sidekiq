module Pliny::Sidekiq::Middleware
  module Client
    class RequestId
      def call(worker_class, msg, queue, redis_pool)
        @args = msg['args']
        msg['request_ids'] = request_id.split(',') if request_id
        yield
      end

      private

      attr_reader :args

      def request_id
        @request_id ||=
          request_id_args || Pliny::RequestStore.store[:request_id]
      end

      def request_id_args
        return nil if !args.last.is_a?(Hash)
        options = args.last
        options[:request_id] || options['request_id']
      end
    end
  end
end
