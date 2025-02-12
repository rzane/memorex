# frozen_string_literal: true

require "bundler/gem_tasks"
require "standard/rake"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

desc "Generate type defininitions from YARD"
task :sord do
  mkdir_p "rbi"
  sh "bundle exec sord rbi/memorex.rbi"

  mkdir_p "sig"
  sh "bundle exec sord sig/memorex.rbs"
end

task default: [:standard, :spec]
