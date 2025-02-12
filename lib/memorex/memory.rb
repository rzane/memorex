# frozen_string_literal: true

module Memorex
  class Memory
    def initialize(memory)
      @memory = memory
    end

    def merge!(values)
      @memory.merge!(values)
      self
    end

    def clear
      @memory.clear
      self
    end

    def delete(key)
      @memory.delete(key)
      self
    end
  end
end
