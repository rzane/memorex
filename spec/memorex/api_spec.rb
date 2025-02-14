# frozen_string_literal: true

RSpec.describe Memorex::API do
  it "provides a helper to manage the cache directly" do
    subject = Class.new {
      extend Memorex
      include Memorex::API

      memoize def value = Counter.increment(:value)
    }.new

    expect(subject.memorex).to be_a(Memorex::Cache)
    expect(subject.value).to be(1)

    subject.memorex.clear
    expect(subject.value).to be(2)
  end
end
