# frozen_string_literal: true

module Limiter
  class Client

    BASE_DOMAIN = "https://api.limiter.dev".freeze

    attr_reader :namespace, :limit, :period, :identifier, :token

    def initialize(namespace:, limit:, period:)
      @namespace = namespace
      @limit = limit
      @period = period.to_i
      @token = ENV["LIMITER_TOKEN"]

      ErrorHandler.error("LIMITER_TOKEN environment variable is not set") if @token.nil?
    end

    def check(identifier)
      @identifier = identifier
      RateLimitResponse.new(request)
    end

    def formatted_period
      case @period
      when 60..3599
        (@period / 60).to_s + "m"
      when 3600..86_399
        (@period / 3600).to_s + "h"
      when 86_400..1_209_599
        (@period / 86_400).to_s + "d"
      else
        ErrorHandler.error("Invalid period")
      end
    end

    def url
      "#{BASE_DOMAIN}/ns/#{namespace}/#{limit}/#{formatted_period}/#{identifier}"
    end

    def request(params = {})
      HTTP.get(url, params: { token: token}.merge(params))
    end
  end
end
