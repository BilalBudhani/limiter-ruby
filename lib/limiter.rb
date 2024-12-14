# frozen_string_literal: true

require_relative "limiter/configuration"
require_relative "limiter/client"
require_relative "limiter/points"
require_relative "limiter/response_handler"
require_relative "limiter/error_handler"
require_relative "limiter/version"
require "logger"

module Limiter
  class Error < StandardError; end

  class << self
    attr_writer :logger, :configuration
  end

  def self.logger
    @logger ||= Logger.new($stdout).tap do |logger|
      logger.progname = "Limiter"
    end
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
