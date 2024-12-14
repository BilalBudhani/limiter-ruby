# frozen_string_literal: true

module Limiter
  class Configuration

    attr_accessor :api_token, :raise_errors

    def initialize
      @api_token = ENV["LIMITER_TOKEN"]
      @raise_errors = true
    end

    def raise_errors?
      @raise_errors
    end
  end
end
