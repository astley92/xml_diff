# frozen_string_literal: true

task default: %w[test lint]

desc "Run tests"
task :test do
  sh "bundle exec rspec"
end

desc "Run linter"
task :lint do
  sh "bundle exec rubocop"
end

desc "Build gem from gemspec"
task :build do
  sh "gem build xml_diff.gemspec"
end

desc "Install gem"
task install: %i[build] do
  sh "gem install xml_diff-#{XmlDiff::VERSION}.gem"
end

desc "Cleanup any gem installations and build artifacts"
task :clean do
  sh "rm -f *.gem"
  sh "gem uninstall xml_diff -x -a"
end
