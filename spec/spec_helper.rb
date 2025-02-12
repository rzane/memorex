# frozen_string_literal: true

require "active_support/concern"
require "memorex"
require "securerandom"
require "sorbet-runtime"

module Once
  def self.calls
    @calls ||= Set.new
  end

  def self.assert(name)
    if calls.add?(name)
      SecureRandom.uuid
    else
      raise "#{name} was already called"
    end
  end
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:each) do
    Once.calls.clear
  end
end
