# frozen_string_literal: true

RSpec.describe 'scenario: inheritance' do
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

  it 'memoizes a method defined in an included module' do
    parent = Module.new do
      extend Memorex
      memoize def value = Once.assert(:value)
    end

    subject = Class.new { include parent }.new
    expect(subject.value).to be(subject.value)
  end

  it 'memoizes a method defined in an included concern' do
    parent = Module.new do
      extend ActiveSupport::Concern
      extend Memorex

      memoize def value = Once.assert(:value)
    end

    subject = Class.new { include parent }.new
    expect(subject.value).to be(subject.value)
  end

  it 'does not memoize an overridden method that is not also memoized' do
    parent = Class.new do
      extend Memorex
      memoize def value = raise('This should not be called')
    end

    subject = Class.new(parent) do
      def value = SecureRandom.uuid
    end.new

    expect(subject.value).not_to eq(subject.value)
  end

  it 'does not memoize an overridden method that invokes super' do
    parent = Class.new do
      extend Memorex
      memoize def value = Once.assert(:value)
    end

    subject = Class.new(parent) do
      def value = super()
    end.new

    expect(subject.value).to be(subject.value)
  end

  it 'does not inherit MemorexMethods module' do
    parent = Class.new do
      extend Memorex
      memoize def foo = Once.assert(:foo)
    end

    child = Class.new(parent) do
      def bar = Once.assert(:bar)
    end

    expect(child::MemorexMethods).to be(parent::MemorexMethods)

    child.memoize(:bar)
    expect(child::MemorexMethods).not_to be(parent::MemorexMethods)
  end

  it 'does not inherit MemorexMethods module from included module' do
    parent = Module.new do
      extend Memorex
      memoize def foo = Once.assert(:foo)
    end

    child = Class.new do
      extend Memorex
      include parent
      def bar = Once.assert(:bar)
    end

    expect(child::MemorexMethods).to be(parent::MemorexMethods)

    child.memoize(:bar)
    expect(child::MemorexMethods).not_to be(parent::MemorexMethods)
  end
end
