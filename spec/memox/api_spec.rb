# frozen_string_literal: true

RSpec.describe Memox::API do
  it "provides a helper to manage the cache directly" do
    subject = Class.new {
      extend Memox
      include Memox::API

      memoize def value = Counter.increment(:value)
    }.new

    expect(subject.memox).to be_a(Memox::Cache)
    expect(subject.value).to be(1)

    subject.memox.clear
    expect(subject.value).to be(2)
  end
end
