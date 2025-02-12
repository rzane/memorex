# frozen_string_literal: true

RSpec.describe Memorex::API do
  it "provides a helper to manage the cache directly" do
    subject = Class.new {
      extend Memorex
      include Memorex::API

      memoize def value = Once.assert(:value)
    }.new

    expect(subject.memorex).to be_a(Memorex::Memory)
    expect(subject.value).to be(subject.value)

    subject.memorex.clear
    expect { subject.value }.to raise_error(Once::Error)
  end
end
