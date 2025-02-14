# frozen_string_literal: true

RSpec.describe "scenario: inheritance" do
  it "memoizes through inheritance" do
    parent = Class.new do
      extend Memox
      memoize def value = Counter.once(:value)
    end

    subject = Class.new(parent).new
    expect(subject.value).to be(subject.value)
  end

  it "memoizes when the parent extends Memox" do
    parent = Class.new { extend Memox }
    subject = Class.new(parent) do
      memoize def value = Counter.once(:value)
    end.new

    expect(subject.value).to be(subject.value)
  end

  it "memoizes a method defined in an included module" do
    parent = Module.new do
      extend Memox
      memoize def value = Counter.once(:value)
    end

    subject = Class.new { include parent }.new
    expect(subject.value).to be(subject.value)
  end

  it "memoizes a method defined in an included concern" do
    parent = Module.new do
      extend ActiveSupport::Concern
      extend Memox

      memoize def value = Counter.once(:value)
    end

    subject = Class.new { include parent }.new
    expect(subject.value).to be(subject.value)
  end

  it "does not memoize an overridden method that is not also memoized" do
    parent = Class.new do
      extend Memox
      memoize def value = raise("This should not be called")
    end

    subject = Class.new(parent) do
      def value = SecureRandom.uuid
    end.new

    expect(subject.value).not_to eq(subject.value)
  end

  it "memoizes an overridden method that invokes super" do
    parent = Class.new do
      extend Memox
      memoize def value = Counter.once(:value)
    end

    subject = Class.new(parent) do
      def value = super
    end.new

    expect(subject.value).to be(subject.value)
  end

  it "does not inherit MemoxMethods module" do
    parent = Class.new do
      extend Memox
      memoize def foo = Counter.once(:foo)
    end

    child = Class.new(parent) do
      def bar = Counter.once(:bar)
    end

    expect(child::MemoxMethods).to be(parent::MemoxMethods)

    child.memoize(:bar)
    expect(child::MemoxMethods).not_to be(parent::MemoxMethods)
  end

  it "does not inherit MemoxMethods module from included module" do
    parent = Module.new do
      extend Memox
      memoize def foo = Counter.once(:foo)
    end

    child = Class.new do
      extend Memox
      include parent
      def bar = Counter.once(:bar)
    end

    expect(child::MemoxMethods).to be(parent::MemoxMethods)

    child.memoize(:bar)
    expect(child::MemoxMethods).not_to be(parent::MemoxMethods)
  end

  it "memoizes through inheritance when frozen" do
    parent = Class.new do
      class << self
        extend Memox
      end
    end

    subject = Class.new(parent) do
      class << self
        memoize def value = Counter.once(:value)
      end
    end

    subject.freeze
    expect(subject.value).to be(subject.value)
  end
end
