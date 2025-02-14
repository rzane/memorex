# frozen_string_literal: true

RSpec.describe Memosa do
  it "has a version number" do
    expect(Memosa::VERSION).not_to be nil
  end

  describe ".reset" do
    it "resets a memoized object" do
      subject = Class.new do
        extend Memosa
        memoize def value = Counter.increment(:value)
      end.new

      expect(subject.value).to eq(1)
      expect(subject.value).to eq(1)

      Memosa.reset(subject)
      expect(subject.value).to eq(2)
    end

    it "tolerates any object" do
      expect { Memosa.reset(nil) }.not_to raise_error
      expect { Memosa.reset(Object) }.not_to raise_error
      expect { Memosa.reset(Object.new) }.not_to raise_error
    end
  end
end
