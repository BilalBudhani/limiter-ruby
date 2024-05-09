# frozen_string_literal: true

module Limiter
  class RateLimitResponse

    attr_reader :response

    def initialize(response)
      @response = response
    end

    def exhausted?
      @response.status == 429
    end

    def allowed?
      @response.status == 200
    end

    private
    def rate_limit_data
      @response.parse
    end
  end
end
