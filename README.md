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
    rate_limit = limiter.check(user.id)

    if rate_limit.exhausted?
      render json: { error: "Rate limit exceeded" }, status: :too_many_requests
    end
  end

  def limiter
    Limiter::Client.new(token: ENV["LIMITER_TOKEN"], namespace: "openai", limit: 60, interval: 1.minute)
  end
end
```
