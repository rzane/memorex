# frozen_string_literal: true

require_relative "memox/cache"
require_relative "memox/internal"
require_relative "memox/version"

# Memox provides a simple way to memoize methods in Ruby.
module Memox
  # Convert a method to a memoized method
  #
  # Memox does not support memoizing methods that accept arguments.
  #
  # @api public
  # @param method_name [Symbol] the name of the method to memoize
  # @return [Symbol] the name of the memoized method
  # @raise [ArgumentError] when the method is is not defined
  # @raise [ArgumentError] when the method is already memoized
  # @example
  #   class State
  #     extend Memox
  #
  #     memoize def id
  #       SecureRandom.uuid
  #     end
  #   end
  #
  def memoize(method_name)
    methods = prepend_memox
    visibility = Internal.visibility(self, method_name)

    if Internal.method_defined?(methods, method_name)
      raise ArgumentError, "`#{method_name.inspect}` is already memoized"
    end

    methods.module_eval(<<~RUBY, __FILE__, __LINE__ + 1)
      #{visibility} def #{method_name}
        raise ArgumentError, "unsupported block argument" if block_given?

        cache = (@_memox_cache ||= {})
        cache.fetch(:#{method_name}) do
          cache[:#{method_name}] = super()
        end
      end
    RUBY

    method_name
  end

  # Define and prepend MemoxMethods
  #
  # When {memoize} is called, Memox will define a module named MemoxMethods. Memoized
  # methods will be defined on this module and then prepended to the class.
  #
  # This method allows you to force that module to be defined and prepended, which is
  # useful when order matters.
  #
  # @api public
  # @return [Module]
  # @example
  #   class Foo
  #     extend Memox
  #     prepend_memox
  #   end
  def prepend_memox
    prepend Initializer

    if const_defined?(:MemoxMethods, false)
      const_get(:MemoxMethods, false)
    else
      const_set(:MemoxMethods, Module.new).tap { |mod| prepend(mod) }
    end
  end

  # Reset an object's memoization cache
  #
  # @api public
  # @param object [Object]
  # @return [void]
  # @example
  #   Memox.reset(user)
  def self.reset(object)
    cache = object.instance_variable_get(:@_memox_cache)
    cache&.clear
    nil
  end

  # This module is responsible for initializing the cache
  #
  # @!visibility private
  module Initializer
    # Eagerly initialize the cache before the object is frozen
    #
    # This ensures that frozen objects can still have memoized methods.
    #
    # @return [self]
    def freeze
      @_memox_cache ||= {}
      super
    end
  end

  # This module provides a {#memox} helper that can be used to manipulate the
  # memoization cache directly.
  module API
    # Used to manipulate the memoized cache directly
    #
    # @api public
    # @return [Memox::Cache]
    # @example
    #   class State
    #     extend Memox
    #     include Memox::API
    #
    #     memoize def id
    #       SecureRandom.uuid
    #     end
    #
    #     def reset!
    #       memox.clear
    #     end
    #   end
    def memox
      ::Memox::Cache.new(@_memox_cache ||= {})
    end
  end
end
