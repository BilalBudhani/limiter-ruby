# frozen_string_literal: true

module Limiter
  class Points < Client

    delegate :remaining, :points, :to => :response

    def limiter_path
      "/pts/#{namespace}/#{limit}/#{formatted_interval}/#{identifier}"
    end

    def used(points)
      @response = ResponseHandler.new(request({ used: points.to_i }))
      self
    end
  end
end
