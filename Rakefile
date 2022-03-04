# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

require "rubocop/rake_task"

RuboCop::RakeTask.new

task default: %i[tag spec rubocop]

# emacs TAGS
desc 'Generates TAG file'
task tag: ['TAGS']
file 'TAGS' do
  sh 'bundle exec ripper-tags -e -R -f TAGS'
end
