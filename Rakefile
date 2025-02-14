# frozen_string_literal: true

require "bundler/gem_tasks"
require "standard/rake"
require "rspec/core/rake_task"

CLOBBER.include("rbi", "sig", ".yardoc")

RSpec::Core::RakeTask.new(:spec)

desc "Generate YARD documentation"
task :yard do
  sh "bundle exec yard"
end

desc "Generate type defininitions from YARD"
task :sord do
  mkdir_p "rbi"
  sh "bundle exec sord rbi/memorex.rbi --hide-private"

  mkdir_p "sig"
  sh "bundle exec sord sig/memorex.rbs --hide-private"
end

task(:build).enhance([:sord])
task default: [:standard, :spec]
