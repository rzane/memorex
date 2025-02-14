# frozen_string_literal: true

RSpec.describe "scenario: errors" do
  it "raises an exception at when memoizing an undefined method" do
    subject = Class.new { extend Memox }
    expect { subject.memoize(:value) }.to raise_error(ArgumentError, "`:value` is not defined")
  end

  it "raises an exception when a public method is already memoized" do
    subject = Class.new do
      extend Memox
      memoize def value = Counter.once(:value)
    end

    expect { subject.memoize(:value) }.to raise_error(ArgumentError, "`:value` is already memoized")
  end

  it "raises an exception when a private method is already memoized" do
    subject = Class.new do
      extend Memox

      private

      memoize def value = Counter.once(:value)
    end

    expect { subject.memoize(:value) }.to raise_error(ArgumentError, "`:value` is already memoized")
  end

  it "raises an exception when a protected method is already memoized" do
    subject = Class.new do
      extend Memox

      protected

      memoize def value = Counter.once(:value)
    end

    expect { subject.memoize(:value) }.to raise_error(ArgumentError, "`:value` is already memoized")
  end

  it "raises an exception when a block argument is provided" do
    subject = Class.new do
      extend Memox
      memoize def value = Counter.once(:value)
    end.new

    expect { subject.value {} }.to raise_error(ArgumentError, "unsupported block argument")
  end
end
