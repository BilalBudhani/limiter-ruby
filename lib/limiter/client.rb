# frozen_string_literal: true

module Limiter
  class Client

    BASE_DOMAIN = "https://api.limiter.dev".freeze

    attr_reader :namespace, :limit, :interval, :identifier, :token

    def initialize(namespace:, limit:, interval:, token: ENV["LIMITER_TOKEN"])
      @namespace = namespace
      @limit = limit
      @interval = interval.to_i
      @token = token || ENV["LIMITER_TOKEN"]
      @logger = Limiter.logger

      ErrorHandler.error("token is not set") if @token.nil?
    end

    def check(identifier)
      @identifier = identifier
      @logger.info("Limiter performing request: #{namespace}/#{limit}/#{interval}/#{identifier}")
      RateLimitResponse.new(request)
    end

    def formatted_interval
      case @interval
      when 1..59
        (@interval).to_s + "s"
      when 60..3599
        (@interval / 60).to_s + "m"
      when 3600..86_399
        (@interval / 3600).to_s + "h"
      when 86_400..1_209_599
        (@interval / 86_400).to_s + "d"
      else
        ErrorHandler.error("Invalid interval")
      end
    end

    def limiter_path
      "/rl/#{namespace}/#{limit}/#{formatted_interval}/#{identifier}"
    end

    def request(params = {})
      @_conn ||= Faraday.new(url: BASE_DOMAIN) do |conn|
        conn.request :authorization, :Bearer, token
        conn.response :json
        conn.adapter Faraday.default_adapter
        conn.headers["User-Agent"] = "Limiter-Ruby/#{Limiter::VERSION}"
      end

      @_conn.get(limiter_path, params)
    end
  end
end
