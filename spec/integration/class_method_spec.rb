# frozen_string_literal: true

RSpec.describe "scenario: class method" do
  it "memoizes a class method" do
    subject = Class.new do
      class << self
        extend Memox
        memoize def value = Counter.once(:value)
      end
    end

    expect(subject.value).to be(subject.value)
  end

  it "defines MemoxMethods" do
    subject = Class.new do
      class << self
        extend Memox
        def value = Counter.once(:value)
      end
    end

    expect(subject.singleton_class.const_defined?(:MemoxMethods)).to be(false)

    subject.singleton_class.memoize(:value)
    expect(subject.singleton_class::MemoxMethods).to be_a(Module)
  end

  it "memoizes a class method when the class is frozen" do
    subject = Class.new do
      class << self
        extend Memox
        memoize def value = Counter.once(:value)
      end
    end

    subject.freeze
    expect(subject.value).to be(subject.value)
  end

  it "preserves the visiblity of a private class method" do
    subject = Class.new do
      class << self
        extend Memox

        private

        memoize def value = Counter.once(:value)
      end
    end

    expect { subject.value }.to raise_error(NoMethodError, /private method [`']value' called/)
    expect(subject.send(:value)).to be(subject.send(:value))
  end

  it "preserves the visibility of a protected class method" do
    subject = Class.new do
      class << self
        extend Memox

        protected

        memoize def value = Counter.once(:value)
      end
    end

    expect { subject.value }.to raise_error(NoMethodError, /protected method [`']value' called/)
    expect(subject.send(:value)).to be(subject.send(:value))
  end
end
