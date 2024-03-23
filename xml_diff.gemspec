# frozen_string_literal: true

require_relative("lib/xml_diff/version")

Gem::Specification.new do |spec|
  spec.name = "xml_diff"
  spec.version = XmlDiff::VERSION
  spec.authors = ["Blake Astley"]
  spec.email = ["astley92@hotmail.com"]

  spec.summary = "A gem to compare two XML files and determine the difference."
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.1"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end

  spec.add_runtime_dependency "nokogiri", "~> 1.12"
  spec.add_runtime_dependency "zeitwerk", "~> 2.6"
end
