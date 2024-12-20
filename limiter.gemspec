# frozen_string_literal: true

require_relative "lib/limiter/version"

Gem::Specification.new do |spec|
  spec.name = "limiter-ruby"
  spec.version = Limiter::VERSION
  spec.authors = ["Bilal Budhani"]
  spec.email = ["bilal@bilalbudhani.com"]

  spec.summary = "Toolkit for building rate limits for your application"
  spec.description = "Limiter is a toolkit for building rate limits for your application. It provides a simple interface to define rate limits and track usage."
  spec.homepage = "https://limiter.dev"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/bilalbudhani/limiter-ruby"
  spec.metadata["changelog_uri"] = "https://github.com/bilalbudhani/limiter-ruby"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "http"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
