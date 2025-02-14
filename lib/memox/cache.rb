# frozen_string_literal: true

module Memox
  # This class is used to interact with the memoization cache.
  # @api public
  class Cache
    # Create a new instance of {Cache}
    #
    # @api private
    # @param cache [Hash<Symbol, BasicObject>] the memoization cache
    def initialize(cache)
      @cache = cache
    end

    # Add values to the cache
    #
    # @api public
    # @param values [Hash<Symbol, BasicObject>] the values to add to the cache.
    # @return [self]
    # @example
    #   memox.merge!(foo: "bar")
    def merge!(values)
      @cache.merge!(values)
      self
    end

    # Reset the cache
    #
    # @api public
    # @return [self]
    # @example
    #   memox.clear
    def clear
      @cache.clear
      self
    end

    # Delete a key from the cache
    #
    # @api public
    # @param key [Symbol]
    # @return [self]
    # @example
    #   memox.delete(:foo)
    def delete(key)
      @cache.delete(key)
      self
    end
  end
end
