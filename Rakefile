# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

require "rubocop/rake_task"

RuboCop::RakeTask.new

task default: %i[tag spec rubocop]

# racc
#desc 'Generates the PolyRuby parsers'
#task racc: ['lib/poly_ruby/poly_m_parser.rb']

#file 'lib/poly_ruby/poly_m_parser.rb' => ['lib/poly_ruby/poly_m_parser.y'] do
  #sh 'bundle exec racc -v -g -o lib/poly_ruby/poly_m_parser.rb lib/poly_ruby/poly_m_parser.y'
  #sh 'bundle exec racc -o lib/poly_ruby/poly_m_parser.rb lib/poly_ruby/poly_m_parser.y'
#end

# emacs TAGS
desc 'Generates TAG file'
task tag: ['TAGS']
file 'TAGS' do
  sh 'bundle exec ripper-tags -e -R -f TAGS'
end
