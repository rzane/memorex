# frozen_string_literal: true

RSpec.describe 'scenario: class method' do
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
end
