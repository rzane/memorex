# frozen_string_literal: true

RSpec.describe "scenario: sorbet" do
  it "memoizes an instance method with a Sorbet signature" do
    subject = Class.new do
      extend Memorex
      extend T::Sig

      sig { returns(String) }
      memoize def value = Once.assert(:value)
    end.new

    expect(subject.value).to be(subject.value)
  end

  it "memoizes an instance method with a Sorbet signature in an included concern" do
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

  it "raises type errors" do
    subject = Class.new do
      extend Memorex
      extend T::Sig

      sig { returns(String) }
      memoize def value = 42
    end.new

    expect { subject.value }.to raise_error(TypeError)
  end
end
