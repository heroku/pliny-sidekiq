# Pliny::Sidekiq

Sidekiq middlewares for making life nicer when using Pliny

 - Passes `request_id`s to and between jobs.
 - logfmts when jobs are enqueued and being processed.
 - Health endpoints for tracking queue latency and depth.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pliny-sidekiq'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pliny-sidekiq

## Usage

Create a `config/initializers/sidekiq.rb` and with the following contents

```ruby
Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add Pliny::Sidekiq::Middleware::Server::RequestId
    chain.add Pliny::Sidekiq::Middleware::Server::Log, metric_prefix: 'my-app'
  end

  config.client_middleware do |chain|
    chain.add Pliny::Sidekiq::Middleware::Client::RequestId
    chain.add Pliny::Sidekiq::Middleware::Client::Log
  end
end

Sidekiq.configure_client do |config|
  config.client_middleware do |chain|
    chain.add Pliny::Sidekiq::Middleware::Client::RequestId
    chain.add Pliny::Sidekiq::Middleware::Client::Log
  end
end
```

To enable the `GET /health/sidekiq` health endpoint add the following to your `lib/routes.rb`

```ruby
mount Pliny::Sidekiq::Endpoints::Health
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake false` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/gudmundur/pliny-sidekiq.

