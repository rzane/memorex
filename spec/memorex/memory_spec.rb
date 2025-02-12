# frozen_string_literal: true

RSpec.describe Memorex::Memory do
  let(:memory) { { a: 100, b: 42 } }
  subject { Memorex::Memory.new(memory) }

  describe '#merge!' do
    it 'adds values to the memory' do
      expect(subject.merge!(foo: 'bar')).to be(subject)
      expect(memory).to eq(a: 100, b: 42, foo: 'bar')
    end
  end

  describe '#delete' do
    it 'deletes values from memory' do
      expect(subject.delete(:a)).to be(subject)
      expect(memory).to eq(b: 42)
    end
  end

  describe '#clear' do
    it 'deletes values from memory' do
      expect(subject.clear).to be(subject)
      expect(memory).to be_empty
    end
  end
end
