# frozen_string_literal: true

require "logger"

module Limiter
  class ErrorHandler
    def self.error(error)
      new(error).handle_error
    end

    def initialize(error)
      @error = error
    end

    def handle_error
      if Limiter.configuration.raise_errors?
        raise Error, @error
      else
        Limiter.logger.error(@error)
      end
    end
  end
end
