# frozen_string_literal: true

module Memorex
  class Memory
    # Create a new instance of {Memory}
    # @api private
    # @param memory [Hash] the memoization cache
    def initialize(memory)
      @memory = memory
    end

    # Add values to the cache
    # @api public
    # @param values [Hash] the values to add to the cache.
    # @return [Memory]
    # @example
    #   memorex.merge!(foo: "bar")
    def merge!(values)
      @memory.merge!(values)
      self
    end

    # Reset the cache
    # @api public
    # @return [Memory]
    # @example
    #   memorex.clear
    def clear
      @memory.clear
      self
    end

    # Delete a key from the cache
    # @api public
    # @param key [Symbol]
    # @return [Memory]
    # @example
    #   memorex.delete(:foo)
    def delete(key)
      @memory.delete(key)
      self
    end
  end
end
