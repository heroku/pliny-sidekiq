require 'sinatra/base'
require 'sidekiq/api'

module Pliny::Sidekiq
  module Endpoints
    class Health < Sinatra::Base
      get '/health/sidekiq' do
        log_health
        MultiJson.encode(health)
      end

      private

      def health
        {
          latency: latency,
          depth:   depth
        }
      end

      def queue
        @queue ||= ::Sidekiq::Queue.new
      end

      def latency
        queue.latency
      end

      def depth
        queue.size
      end

      def log_prefix
        "measure#sidekiq."
      end

      def log_health
        data = {
          sidekiq: true,
          health:  true
        }.merge(Hash[health.map { |k, v| ["#{log_prefix}#{k}", v] }])

        Pliny.log(data)
      end
    end
  end
end
