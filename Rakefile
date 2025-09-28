# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task default: :spec

desc 'Run all checks'
task check: :spec

desc 'Build and push gem to RubyGems'
task :push do
  Rake::Task['build'].invoke
  Rake::Task['release'].invoke
end