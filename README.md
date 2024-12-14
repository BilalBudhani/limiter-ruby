# Limiter

[Limiter.dev](https://limiter.dev) enables building rate limits for your application with ease. It provides a simple interface to define rate limits and track usage.

## Usage

### Generate API Token

Before using the gem you must register at <https://limiter.dev> and generate an token to interact with the api. Thereafter, add the token to app's environment variable

```
LIMITER_TOKEN: [GENERATED TOKEN]
```

### Install the gem

In the `Gemfile` add the following

```ruby
gem "limiter-ruby"
```

### Configure the gem

In the `config/initializers/limiter.rb` file add the following

```ruby
Limiter.configure do |config|
  config.api_token = ENV["LIMITER_TOKEN"]
  config.raise_errors = true
end
```

## Simple Rate Limit Example

Assuming this is a Ruby on Rails app within ActiveJob

```ruby
class ApiController < ApplicationController
  before_action :rate_limit

  def index
    # Good to continue
  end

  private
  def rate_limit
    # check the rate limit for the current user and increment the request count
    rate_limit = limiter.check(current_user.id)

    if rate_limit.exceeded?
      render json: { error: "Rate limit exceeded" }, status: :too_many_requests
    end
  end

  # Allow 120 requests per minute
  def limiter
    Limiter::Client.new(namespace: "openai", limit: 120, interval: 1.minute)
  end
end
```

## Points Rate Limit Example

```ruby
class ApiController < ApplicationController
  before_action :rate_limit

  def index
    # continue the action

    limiter.used(100) # mark 100 points used
  end

  private
  def rate_limit
    rate_limit = limiter.check(current_user.id)

    if rate_limit.exhausted?
      render json: { error: "Rate limit exceeded" }, status: :too_many_requests
    end
  end

 # Allow 1000 points per minute
  def limiter
    Limiter::Points.new(namespace: "shopify", limit: 1000, interval: 1.minute)
  end
end
```
