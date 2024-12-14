# frozen_string_literal: true

module Limiter
  class ResponseHandler

    attr_reader :response

    def initialize(response)
      @response = response
    end

    def exhausted?
      signed_request? && @response.status == 429
    end
    alias_method :exceeded?, :exhausted?

    def allowed?
      signed_request? && @response.status == 200
    end

    def resets_in
      if signed_request? && !resets_at.nil?
        (Time.parse(resets_at) - Time.now)
      else
        0
      end
    end

    def resets_at
      response_data["resetsAt"]
    end

    def remaining
      response_data["remaining"]
    end

    def points
      response_data["points"]
    end

    def signed_request?
      @response.headers["X-Limiter-Signed"].to_s == "true"
    end

    private
    def response_data
      @_body ||= @response.parse
    end
  end
end
