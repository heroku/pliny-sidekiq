module Pliny::Sidekiq::Middleware
  module Server
    class RequestId
      def initialize(store: Pliny::RequestStore)
        @store = store
      end

      def call(worker, job, queue)
        @store.clear!
        @store.seed({
          'REQUEST_IDS' => job['request_ids']
        }) if job.include?('request_ids')

        yield
      end
    end
  end
end
