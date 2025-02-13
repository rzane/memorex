# frozen_string_literal: true

require_relative "memorex/internal"
require_relative "memorex/memory"
require_relative "memorex/version"

# Memorex provides a simple way to memoize methods in Ruby.
module Memorex
  # Convert a method to a memoized method
  #
  # Memorex does not support memoizing methods that accept arguments.
  #
  # @api public
  # @param method_name [Symbol] the name of the method to memoize
  # @return [Symbol] the name of the memoized method
  # @raise [ArgumentError] when the method is is not defined
  # @raise [ArgumentError] when the method is already memoized
  #
  # @example
  #   class State
  #     extend Memorex
  #
  #     memoize def id
  #       SecureRandom.uuid
  #     end
  #   end
  #
  def memoize(method_name)
    visibility = Internal.visibility(self, method_name)
    methods = Internal.methods_module(self)

    if Internal.method_defined?(methods, method_name)
      raise ArgumentError, "`#{method_name.inspect}` is already memoized"
    end

    methods.module_eval(<<~RUBY, __FILE__, __LINE__ + 1)
      #{visibility} def #{method_name}
        raise ArgumentError, "unsupported block argument" if block_given?

        cache = (@_memorex_cache ||= {})
        cache.fetch(:#{method_name}) do
          cache[:#{method_name}] = super()
        end
      end
    RUBY

    method_name
  end

  # A clone of this module will be prepended to the class that invoked `memoize`.
  # @api private
  module Methods
    # This is a best effort attempt to initialize the cache at initialization time
    #
    # Since the cache would otherwise be assigned lazily, this decreases the risk
    # of two threads trying to lazily initialize the cache at the same time.
    #
    # @return [void]
    def initialize(...)
      @_memorex_cache = {}
      super
    end

    # Eagerly initialize the cache before the object is frozen
    #
    # This ensures that frozen objects can still have memoized methods.
    #
    # @return [self]
    def freeze
      @_memorex_cache ||= {}
      super
    end
  end

  # This module provides a {#memorex} helper that can be used to manipulate the
  # memoization cache directly.
  module API
    # Used to manipulate the memoized cache directly
    #
    # @api public
    # @return [Memorex::Memory]
    #
    # @example
    #   class State
    #     extend Memorex
    #     include Memorex::API
    #
    #     memoize def id
    #       SecureRandom.uuid
    #     end
    #
    #     def reset!
    #       memorex.clear
    #     end
    #   end
    def memorex
      ::Memorex::Memory.new(@_memorex_cache ||= {})
    end
  end
end
