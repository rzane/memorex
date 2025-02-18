# frozen_string_literal: true

RSpec.describe "scenario: class method" do
  it "memoizes a class method" do
    subject = Class.new do
      class << self
        extend Memosa
        memoize def value = Counter.once(:value)
      end
    end

    expect(subject.value).to be(subject.value)
  end

  it "defines MemosaMethods" do
    subject = Class.new do
      class << self
        extend Memosa
      end
    end

    expect(subject.singleton_class::MemosaMethods).to be_a(Module)
    expect(subject.singleton_class.ancestors).to include(subject.singleton_class::MemosaMethods)
  end

  it "memoizes a class method when the class is frozen" do
    subject = Class.new do
      class << self
        extend Memosa
        memoize def value = Counter.once(:value)
      end
    end

    subject.freeze
    expect(subject.value).to be(subject.value)
  end

  it "preserves the visiblity of a private class method" do
    subject = Class.new do
      class << self
        extend Memosa

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
        extend Memosa

        protected

        memoize def value = Counter.once(:value)
      end
    end

    expect { subject.value }.to raise_error(NoMethodError, /protected method [`']value' called/)
    expect(subject.send(:value)).to be(subject.send(:value))
  end
end
