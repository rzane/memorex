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
  rm_rf "rbi"
  mkdir "rbi"
  sh "bundle exec sord rbi/memosa.rbi --hide-private"

  rm_rf "sig"
  mkdir "sig"
  sh "bundle exec sord sig/memosa.rbs --hide-private"
end

task(:build).enhance([:sord])
task default: [:standard, :spec]
