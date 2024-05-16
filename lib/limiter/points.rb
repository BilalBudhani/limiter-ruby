# frozen_string_literal: true

module Limiter
  class Points < Client
    def initialize(namespace, points, period)
      super(namespace: namespace, limit: points, period: period)
    end

    def url
      "#{BASE_DOMAIN}/points/#{namespace}/#{limit}/#{formatted_period}/#{identifier}"
    end

    def used(points)
      RateLimitResponse.new(request({ used: points.to_i }))
    end
  end
end
