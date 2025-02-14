# frozen_string_literal: true

require "active_support/concern"
require "memox"
require "securerandom"
require "sorbet-runtime"

module Counter
  Error = Class.new(StandardError)

  def self.state
    @state ||= Hash.new(0)
  end

  def self.increment(key)
    state[key] += 1
  end

  def self.once(key)
    value = Counter.increment(key)
    raise Error, "#{name} was already called" if value != 1
    value
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
    Counter.state.clear
  end
end
