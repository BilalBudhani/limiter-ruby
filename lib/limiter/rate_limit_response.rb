# frozen_string_literal: true

module Limiter
  class RateLimitResponse

    attr_reader :response

    def initialize(response)
      @response = response
    end

    def exhausted?
      signed_request? && @response.status == 429
    end

    def allowed?
      signed_request? && @response.status == 200
    end

    def signed_request?
      @response.headers["X-Limiter-Signed"].to_s == "true"
    end

    private
    def rate_limit_data
      @response.parse
    end
  end
end
