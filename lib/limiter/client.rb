# frozen_string_literal: true

module Limiter
  class Client

    BASE_DOMAIN = "https://api.limiter.dev".freeze

    attr_reader :namespace, :limit, :period, :identifier, :response, :token

    def initialize(namespace:, limit:, period:)
      @namespace = namespace
      @limit = limit
      @period = period.to_i
      @token = ENV["LIMITER_TOKEN"]
      @response = nil

      raise Error, "LIMITER_TOKEN environment variable is not set" if @token.nil?
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
        raise Error, "Invalid period"
      end
    end

    def url
      "#{BASE_DOMAIN}/#{namespace}/#{limit}/#{formatted_period}/#{identifier}"
    end

    def request
      @response = HTTP.get(url, params: { token: token})
    end
  end
end
