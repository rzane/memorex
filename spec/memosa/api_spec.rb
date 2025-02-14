# frozen_string_literal: true

RSpec.describe Memosa::API do
  it "provides a helper to manage the cache directly" do
    subject = Class.new {
      extend Memosa
      include Memosa::API

      memoize def value = Counter.increment(:value)
    }.new

    expect(subject.memosa).to be_a(Memosa::Cache)
    expect(subject.value).to be(1)

    subject.memosa.clear
    expect(subject.value).to be(2)
  end
end
