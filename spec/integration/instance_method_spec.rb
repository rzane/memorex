# frozen_string_literal: true

RSpec.describe "scenario: instance method" do
  it "memoizes an instance method" do
    subject = Class.new do
      extend Memorex
      memoize def value = Counter.once(:value)
    end.new

    expect(subject.value).to be(subject.value)
  end

  it "defines MemorexMethods" do
    subject = Class.new do
      extend Memorex
      def value = Counter.once(:value)
    end

    expect(subject.const_defined?(:MemorexMethods)).to be(false)

    subject.memoize(:value)
    expect(subject::MemorexMethods).to be_a(Module)
    expect(subject.ancestors).to include(subject::MemorexMethods)
  end

  it "memoizes an instance method when the object is frozen" do
    subject = Class.new do
      extend Memorex
      memoize def value = Counter.once(:value)
    end.new

    subject.freeze
    expect(subject.value).to be(subject.value)
  end

  it "preserves the visiblity of a private instance method" do
    subject = Class.new do
      extend Memorex

      private

      memoize def value = Counter.once(:value)
    end.new

    expect { subject.value }.to raise_error(NoMethodError, /private method `value' called/)
    expect(subject.send(:value)).to be(subject.send(:value))
  end

  it "preserves the visibility of a protected instance method" do
    subject = Class.new do
      extend Memorex

      protected

      memoize def value = Counter.once(:value)
    end.new

    expect { subject.value }.to raise_error(NoMethodError, /protected method `value' called/)
    expect(subject.send(:value)).to be(subject.send(:value))
  end
end
