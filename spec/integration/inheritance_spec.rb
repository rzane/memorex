# frozen_string_literal: true

RSpec.describe "scenario: inheritance" do
  it "memoizes through inheritance" do
    parent = Class.new do
      extend Memosa
      memoize def value = Counter.once(:value)
    end

    subject = Class.new(parent).new
    expect(subject.value).to be(subject.value)
  end

  it "memoizes when the parent extends Memosa" do
    parent = Class.new { extend Memosa }
    subject = Class.new(parent) do
      memoize def value = Counter.once(:value)
    end.new

    expect(subject.value).to be(subject.value)
  end

  it "memoizes a method defined in an included module" do
    parent = Module.new do
      extend Memosa
      memoize def value = Counter.once(:value)
    end

    subject = Class.new { include parent }.new
    expect(subject.value).to be(subject.value)
  end

  it "memoizes a method defined in an included concern" do
    parent = Module.new do
      extend ActiveSupport::Concern
      extend Memosa

      memoize def value = Counter.once(:value)
    end

    subject = Class.new { include parent }.new
    expect(subject.value).to be(subject.value)
  end

  it "does not memoize an overridden method that is not also memoized" do
    parent = Class.new do
      extend Memosa
      memoize def value = raise("This should not be called")
    end

    subject = Class.new(parent) do
      def value = SecureRandom.uuid
    end.new

    expect(subject.value).not_to eq(subject.value)
  end

  it "memoizes an overridden method that invokes super" do
    parent = Class.new do
      extend Memosa
      memoize def value = Counter.once(:value)
    end

    subject = Class.new(parent) do
      def value = super
    end.new

    expect(subject.value).to be(subject.value)
  end

  it "does not inherit MemosaMethods module" do
    parent = Class.new do
      extend Memosa
      memoize def foo = Counter.once(:foo)
    end

    child = Class.new(parent)

    expect(child::MemosaMethods).not_to be(parent::MemosaMethods)
  end

  it "does not inherit MemosaMethods module from included module" do
    parent = Module.new do
      extend Memosa
      memoize def foo = Counter.once(:foo)
    end

    child = Class.new do
      extend Memosa
      include parent
    end

    expect(child::MemosaMethods).not_to be(parent::MemosaMethods)
  end

  it "memoizes through inheritance when frozen" do
    parent = Class.new do
      class << self
        extend Memosa
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

  it "only prepends Initializer once" do
    a = Class.new { extend Memosa }
    b = Class.new(a) { memoize def x = 100 }
    expect(b.ancestors.count(Memosa::Initializer)).to eq(1)

    a.class_eval { memoize def y = 100 }
    expect(b.ancestors.count(Memosa::Initializer)).to eq(1)
    expect(b.ancestors).to include(a::MemosaMethods)
  end

  it "prepends MemosaMethods with multiple levels of singleton class inheritance" do
    a = Class.new { extend Memosa }
    b = Class.new(a)
    c = Class.new(b) { memoize def value = 100 }

    expect(b::MemosaMethods).not_to be(a::MemosaMethods)
    expect(c::MemosaMethods).not_to be(b::MemosaMethods)
  end

  it "prepends MemosaMethods with multiple levels of singleton class inheritance" do
    a = Class.new { class << self; extend Memosa; end }
    b = Class.new(a)
    c = Class.new(b) { class << self; memoize def value = 100; end }

    expect(b.singleton_class::MemosaMethods).not_to be(a.singleton_class::MemosaMethods)
    expect(c.singleton_class::MemosaMethods).not_to be(b.singleton_class::MemosaMethods)
  end
end
