# frozen_string_literal: true

RSpec.describe "scenario: errors" do
  it "raises an exception when Memorex is used twice" do
    subject = Class.new { extend Memorex }
    stub_const("Foo", subject)

    expect { subject.extend(Memorex) }.to raise_error(ArgumentError, "`Foo` extended Memorex more than once")
  end

  it "raises an exception at when memoizing an undefined method" do
    subject = Class.new { extend Memorex }
    expect { subject.memoize(:value) }.to raise_error(ArgumentError, "`:value` is not defined")
  end

  it "raises an exception when a public method is already memoized" do
    subject = Class.new do
      extend Memorex
      memoize def value = Once.assert(:value)
    end

    expect { subject.memoize(:value) }.to raise_error(ArgumentError, "`:value` is already memoized")
  end

  it "raises an exception when a private method is already memoized" do
    subject = Class.new do
      extend Memorex

      private

      memoize def value = Once.assert(:value)
    end

    expect { subject.memoize(:value) }.to raise_error(ArgumentError, "`:value` is already memoized")
  end

  it "raises an exception when a protected method is already memoized" do
    subject = Class.new do
      extend Memorex

      protected

      memoize def value = Once.assert(:value)
    end

    expect { subject.memoize(:value) }.to raise_error(ArgumentError, "`:value` is already memoized")
  end

  it "raises an exception when a block argument is provided" do
    subject = Class.new do
      extend Memorex
      memoize def value = Once.assert(:value)
    end.new

    expect { subject.value {} }.to raise_error(ArgumentError, "unsupported block argument")
  end
end
