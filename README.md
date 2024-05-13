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
gem "limiter"
```

## Integrate

Assuming this is a Ruby on Rails app within ActiveJob

```ruby
class ExpensiveJob < ApplicationJob

  def perform
    rate_limit = limiter.check(user.id) # A unique identifier

    if rate_limit.exhausted? # Rate limit got hit
      self.class.set(wait: rate_limit.resets_in).perform_later(..args)
      return
    end

    # Good to continue expensive operation
    # ...
  end

  private
  def limiter
    Limiter::Client.new(namespace: "openai", limit: 60, period: 1.minute)
  end
end
```
