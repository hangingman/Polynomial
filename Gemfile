# frozen_string_literal: true

source "https://rubygems.org"

# Specify your gem's dependencies in poly_ruby.gemspec
gemspec
gem "rake", "~> 13.0"
gem "smithereen", :git => 'https://github.com/glv/smithereen.git'
gem "activesupport"
gem "bigdecimal", "1.3.5" # https://stackoverflow.com/a/60491254/2565527
gem "rexml"

group :test do
  gem "rspec", "~> 3.0"
  gem "rubocop", "~> 1.69", require: false
  gem "rubocop-rake"
  gem "rubocop-rspec"
  gem "rspec-parameterized-context"
end

group :development do
  gem "ripper-tags", "= 0.9.0"
  gem "pry"
end
