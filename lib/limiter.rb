# frozen_string_literal: true

require "http"
require_relative "limiter/client"
require_relative "limiter/rate_limit_response"
require_relative "limiter/version"

module Limiter
  class Error < StandardError; end
end
