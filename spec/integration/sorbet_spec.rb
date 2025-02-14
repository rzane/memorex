# frozen_string_literal: true

RSpec.describe "scenario: sorbet" do
  it "memoizes an instance method with a Sorbet signature" do
    subject = Class.new do
      extend Memosa
      extend T::Sig

      sig { returns(Integer) }
      memoize def value = Counter.once(:value)
    end.new

    expect(subject.value).to be(subject.value)
  end

  it "memoizes an instance method with a Sorbet signature in an included concern" do
    parent = Module.new do
      extend ActiveSupport::Concern
      extend T::Sig
      extend Memosa

      sig { returns(Integer) }
      memoize def value = Counter.once(:value)
    end

    subject = Class.new { include parent }.new
    expect(subject.value).to be(subject.value)
  end

  it "raises type errors" do
    subject = Class.new do
      extend Memosa
      extend T::Sig

      sig { returns(String) }
      memoize def value = 42
    end.new

    expect { subject.value }.to raise_error(TypeError)
  end

  it "does not raise when `#initialize` is defined" do
    subject = Class.new do
      extend T::Sig
      extend Memosa

      # Ideally, this would eagerly instantiate the cache in `#initialize`.
      # Sorbet won't let us prepend methods before the sig is added.
      # See: https://github.com/sorbet/sorbet/issues/5025
      #
      # Options:
      # 1. Override `.new` and instantiate the cache there
      # 2. Tap into `method_added`, undefine `#initialize` and redefine it after the sig is added
      prepend_memosa

      sig { void }
      def initialize
      end

      memoize def value = Counter.once(:value)
    end.new

    expect(subject.value).to be(subject.value)
  end
end
