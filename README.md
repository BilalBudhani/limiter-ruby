# Limiter

[Limiter.dev](https://limiter.dev) enables apps to play nice with third party API rate limits and stays within the defined boundaries with a simple mechanism.

## Generate API Token

Before using the gem you must register at <https://limiter.dev> and generate an token to interact with the api. Thereafter, add the token to app's environment variable

```
LIMITER_TOKEN: [GENERATED TOKEN]
```

## Install the gem

In the `Gemfile` add the following

```ruby
gem "limiter"
```

## Usage

Assuming this is a Ruby on Rails app within ActiveJob

```ruby
class ExpensiveJob < ApplicationJob


  def perform
    rate_limit = limiter.check(user.id) # A unique identifier

    if rate_limit.exhausted? # Rate limit got hit
      self.class.set(wait: 1.minute).perform_later(..args)
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
