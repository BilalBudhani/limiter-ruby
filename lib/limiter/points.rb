# frozen_string_literal: true

module Limiter
  class Points < Client

    def url
      "#{BASE_DOMAIN}/points/#{namespace}/#{limit}/#{formatted_period}/#{identifier}"
    end

    def used(points)
      RateLimitResponse.new(request({ used: points.to_i }))
    end
  end
end
