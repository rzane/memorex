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
    methods = prepend_memorex
    visibility = Internal.visibility(self, method_name)

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

  # Define and prepend MemorexMethods
  #
  # When {memoize} is called, Memorex will define a module named MemorexMethods. Memoized
  # methods will be defined on this module and then prepended to the class.
  #
  # This method allows you to force that module to be defined and prepended, which is
  # useful when order matters.
  #
  # @api public
  # @return [Module]
  # @example
  #   class Foo
  #     extend Memorex
  #     prepend_memorex
  #   end
  def prepend_memorex
    prepend Initializer

    if const_defined?(:MemorexMethods, false)
      const_get(:MemorexMethods, false)
    else
      const_set(:MemorexMethods, Module.new).tap { |mod| prepend(mod) }
    end
  end

  # This module is responsible for initializing the cache
  #
  # @api private
  module Initializer
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
