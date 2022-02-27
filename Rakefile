# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

require "rubocop/rake_task"

RuboCop::RakeTask.new

task default: %i[racc spec rubocop]

# racc
desc 'Generates the PolyRuby parsers'
task racc: ['lib/poly_ruby/poly_m_parser.rb']

file 'lib/poly_ruby/poly_m_parser.rb' => ['lib/poly_ruby/poly_m_parser.y'] do
  #sh 'racc -v -g -o lib/poly_ruby/poly_m_parser.rb lib/poly_ruby/poly_m_parser.y'
  sh 'racc -o lib/poly_ruby/poly_m_parser.rb lib/poly_ruby/poly_m_parser.y'
end
