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

    def resets_in
      if signed_request? && !resets_at.nil?
        (Time.parse(resets_at) - Time.now).to_i
      else
        0
      end
    end

    def signed_request?
      @response.headers["X-Limiter-Signed"].to_s == "true"
    end

    private
    def rate_limit_data
      @_body ||= @response.parse
    end

    def resets_at
      rate_limit_data["resetsAt"]
    end
  end
end
