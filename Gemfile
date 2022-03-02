# frozen_string_literal: true

source "https://rubygems.org"

# Specify your gem's dependencies in poly_ruby.gemspec
gemspec
gem "rake", "~> 13.0"
gem "smithereen", :git => 'https://github.com/glv/smithereen.git'

group :test do
  gem "rspec", "~> 3.0"
  gem "rubocop", "~> 0.80"
  gem "rspec-parameterized-context"
end

group :development do
  gem "ripper-tags", "= 0.9.0"
  gem "racc", "= 1.6.0"
  gem "pry"
end
