# frozen_string_literal: true

RSpec.describe Memox do
  it "has a version number" do
    expect(Memox::VERSION).not_to be nil
  end

  describe ".reset" do
    it "resets a memoized object" do
      subject = Class.new do
        extend Memox
        memoize def value = Counter.increment(:value)
      end.new

      expect(subject.value).to eq(1)
      expect(subject.value).to eq(1)

      Memox.reset(subject)
      expect(subject.value).to eq(2)
    end

    it "tolerates any object" do
      expect { Memox.reset(nil) }.not_to raise_error
      expect { Memox.reset(Object) }.not_to raise_error
      expect { Memox.reset(Object.new) }.not_to raise_error
    end
  end
end
