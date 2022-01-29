# frozen_string_literal: true

require_relative "lib/valorant_daily_store/version"

Gem::Specification.new do |spec|
  spec.name = "valorant_daily_store"
  spec.version = ValorantDailyStore::VERSION
  spec.authors = ["Vegann"]
  spec.email = ["git@vegann.anonaddy.com"]

  spec.summary = "Get your valorant daily store"
  spec.homepage = "https://github.com/Vegann/valorant_daily_store"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/Vegann/valorant_daily_store"
  spec.metadata["changelog_uri"] = "https://github.com/Vegann/valorant_daily_store/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday-cookie_jar", "~> 0.0.7"
  spec.add_dependency "faraday", "~> 2.1"
  spec.add_dependency "thor", "~> 1.2.1"

  spec.add_development_dependency "bundler", "~> 2.3.3"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry", "~> 0.14.1"
  spec.add_development_dependency "standard", "~> 1.3"
  spec.add_development_dependency "vcr", "~> 6.0"
  spec.add_development_dependency "webmock", "~> 3.14"
end
