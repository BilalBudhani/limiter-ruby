# frozen_string_literal: true
require "logger"

module Limiter
  class ErrorHandler
    def self.error(error)
      new(error).handle_error
    end

    def initialize(error)
      @error = error
      @logger = Logger.new(STDOUT)
    end

    def handle_error
      if !production?
        raise Error, @error
      else
        log @error
      end
    end

    def production?
      if defined?(Rails)
        Rails.env.production?
      else
        (ENV["RACK_ENV"] || ENV["RAILS_ENV"] ) == "production"
      end
    end

    def log(error)
      @logger.error(error)
    end
  end
end
