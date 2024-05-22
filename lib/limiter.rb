# frozen_string_literal: true

require "http"
require "limiter/client"
require "limiter/points"
require "limiter/rate_limit_response"
require "limiter/error_handler"
require "limiter/version"

module Limiter
  class Error < StandardError; end
end
