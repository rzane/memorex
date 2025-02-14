# frozen_string_literal: true

RSpec.describe Memox::Cache do
  let(:cache) { {a: 100, b: 42} }
  subject { Memox::Cache.new(cache) }

  describe "#merge!" do
    it "adds values to the cache" do
      expect(subject.merge!(foo: "bar")).to be(subject)
      expect(cache).to eq(a: 100, b: 42, foo: "bar")
    end
  end

  describe "#delete" do
    it "deletes values from cache" do
      expect(subject.delete(:a)).to be(subject)
      expect(cache).to eq(b: 42)
    end
  end

  describe "#clear" do
    it "deletes values from cache" do
      expect(subject.clear).to be(subject)
      expect(cache).to be_empty
    end
  end
end
