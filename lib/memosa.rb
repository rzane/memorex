# frozen_string_literal: true

require_relative "memosa/cache"
require_relative "memosa/internal"
require_relative "memosa/version"

# Memosa provides a simple way to memoize methods in Ruby.
module Memosa
  # Called when Memorex is extended
  # @api private
  # @param base [Module]
  # @return [void]
  def self.extended(base)
    base.prepend(Initializer)
  end

  # Convert a method to a memoized method
  #
  # Memosa does not support memoizing methods that accept arguments.
  #
  # @api public
  # @param method_name [Symbol] the name of the method to memoize
  # @return [Symbol] the name of the memoized method
  # @raise [ArgumentError] when the method is is not defined
  # @raise [ArgumentError] when the method is already memoized
  # @example
  #   class State
  #     extend Memosa
  #
  #     memoize def id
  #       SecureRandom.uuid
  #     end
  #   end
  #
  def memoize(method_name)
    methods = prepend_memosa
    visibility = Internal.visibility(self, method_name)

    if Internal.method_defined?(methods, method_name)
      raise ArgumentError, "`#{method_name.inspect}` is already memoized"
    end

    methods.module_eval(<<~RUBY, __FILE__, __LINE__ + 1)
      #{visibility} def #{method_name}
        raise ArgumentError, "unsupported block argument" if block_given?

        cache = (@_memosa_cache ||= {})
        cache.fetch(:#{method_name}) do
          cache[:#{method_name}] = super()
        end
      end
    RUBY

    method_name
  end

  # Define and prepend MemosaMethods
  #
  # When {memoize} is called, Memosa will define a module named MemosaMethods. Memoized
  # methods will be defined on this module and then prepended to the class.
  #
  # This method allows you to force that module to be defined and prepended, which is
  # useful when order matters.
  #
  # @api public
  # @return [Module]
  # @example
  #   class Foo
  #     extend Memosa
  #     prepend_memosa
  #   end
  def prepend_memosa
    if const_defined?(:MemosaMethods, false)
      const_get(:MemosaMethods, false)
    else
      const_set(:MemosaMethods, Module.new).tap { |mod| prepend(mod) }
    end
  end

  # Reset an object's memoization cache
  #
  # @api public
  # @param object [Object]
  # @return [void]
  # @example
  #   Memosa.reset(user)
  def self.reset(object)
    cache = object.instance_variable_get(:@_memosa_cache)
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
      @_memosa_cache ||= {}
      super
    end
  end

  # This module provides a {#memosa} helper that can be used to manipulate the
  # memoization cache directly.
  module API
    # Used to manipulate the memoized cache directly
    #
    # @api public
    # @return [Memosa::Cache]
    # @example
    #   class State
    #     extend Memosa
    #     include Memosa::API
    #
    #     memoize def id
    #       SecureRandom.uuid
    #     end
    #
    #     def reset!
    #       memosa.clear
    #     end
    #   end
    def memosa
      ::Memosa::Cache.new(@_memosa_cache ||= {})
    end
  end
end
