# frozen_string_literal: true

require "http"

module Limiter
  class Client

    BASE_URL = "https://api.limiter.dev"

    attr_reader :namespace, :limit, :interval, :identifier, :token, :response
    delegate :exhausted?, :allowed?, :exceeded?, :resets_in, :to => :response

    def initialize(namespace:, limit:, interval:)
      @namespace = namespace
      @limit = limit
      @interval = interval.to_i
      @logger = Limiter.logger

      ErrorHandler.error("API Token is not set") if Limiter.configuration.api_token.nil?
    end

    def check(identifier)
      @identifier = identifier
      @logger.info("check: #{namespace}/#{limit}/#{interval}/#{identifier}")
      @response = ResponseHandler.new(request)
      self
    rescue => e
      ErrorHandler.error("check failed: #{e.message}")
      self
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
      "/ctr/#{namespace}/#{limit}/#{formatted_interval}/#{identifier}"
    end

    def request(params = {})
      ::HTTP
        .auth("Bearer #{Limiter.configuration.api_token}")
        .headers("User-Agent" => "Limiter-Ruby/#{Limiter::VERSION}")
        .get(BASE_URL + limiter_path, params: params)
    end
  end
end
