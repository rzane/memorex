# frozen_string_literal: true

RSpec.describe Memorex do
  it "has a version number" do
    expect(Memorex::VERSION).not_to be nil
  end

  it 'memoizes an instance method' do
    subject = Class.new do
      extend Memorex
      memoize def value = Once.assert(:value)
    end.new

    expect(subject.value).to be(subject.value)
  end

  it 'preserves the visiblity of a private instance method' do
    subject = Class.new do
      extend Memorex
      private
      memoize def value = Once.assert(:value)
    end.new

    expect { subject.value }.to raise_error(NoMethodError, /private method `value' called/)
    expect(subject.send(:value)).to be(subject.send(:value))
  end

  it 'preserves the visibility of a protected instance method' do
    subject = Class.new do
      extend Memorex
      protected
      memoize def value = Once.assert(:value)
    end.new

    expect { subject.value }.to raise_error(NoMethodError, /protected method `value' called/)
    expect(subject.send(:value)).to be(subject.send(:value))
  end

  it 'memoizes a class method' do
    subject = Class.new do
      class << self
        extend Memorex
        memoize def value = Once.assert(:value)
      end
    end

    expect(subject.value).to be(subject.value)
  end

  it 'preserves the visiblity of a private class method' do
    subject = Class.new do
      class << self
        extend Memorex
        private
        memoize def value = Once.assert(:value)
      end
    end

    expect { subject.value }.to raise_error(NoMethodError, /private method `value' called/)
    expect(subject.send(:value)).to be(subject.send(:value))
  end

  it 'preserves the visibility of a protected class method' do
    subject = Class.new do
      class << self
        extend Memorex
        protected
        memoize def value = Once.assert(:value)
      end
    end

    expect { subject.value }.to raise_error(NoMethodError, /protected method `value' called/)
    expect(subject.send(:value)).to be(subject.send(:value))
  end

  it 'memoizes through inheritance' do
    parent = Class.new do
      extend Memorex
      memoize def value = Once.assert(:value)
    end

    subject = Class.new(parent).new
    expect(subject.value).to be(subject.value)
  end

  it 'memoizes when the parent extends Memorex' do
    parent = Class.new { extend Memorex }
    subject = Class.new(parent) do
      memoize def value = Once.assert(:value)
    end.new

    expect(subject.value).to be(subject.value)
  end

  it 'memoizes through inclusion' do
    parent = Module.new do
      extend Memorex
      memoize def value = Once.assert(:value)
    end

    subject = Class.new { include parent }.new
    expect(subject.value).to be(subject.value)
  end

  it 'memoizes through concern' do
    parent = Module.new do
      extend ActiveSupport::Concern
      extend Memorex

      memoize def value = Once.assert(:value)
    end

    subject = Class.new { include parent }.new
    expect(subject.value).to be(subject.value)
  end

  it 'memoizes an instance method with a Sorbet signature' do
    subject = Class.new do
      extend Memorex
      extend T::Sig

      sig { returns(String) }
      memoize def value = Once.assert(:value)
    end.new

    expect(subject.value).to be(subject.value)
  end

  it 'memoizes an instance method with a Sorbet signature in a concern' do
    parent = Module.new do
      extend ActiveSupport::Concern
      extend T::Sig
      extend Memorex

      sig { returns(String) }
      memoize def value = Once.assert(:value)
    end

    subject = Class.new { include parent }.new
    expect(subject.value).to be(subject.value)
  end
end
