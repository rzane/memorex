# frozen_string_literal: true

module Memorex
  # These methods are use internally by Memorex and are not intended for public use.
  # @api private
  module Internal
    # Define MemorexMethods
    # @param owner [Module]
    # @return [Module]
    def self.define_methods(owner)
      if owner.const_defined?(:MemorexMethods, false)
        raise ArgumentError, "`#{owner}` extended Memorex more than once"
      end

      owner.const_set(:MemorexMethods, Module.new)
    end

    # Retreive MemorexMethods
    # @param owner [Module]
    # @return [Module]
    def self.lookup_methods(owner)
      owner.const_get(:MemorexMethods, false)
    end

    # Determine the visibility of a method
    # @param owner [Module]
    # @param method_name [Symbol]
    # @return [Symbol]
    def self.visibility(owner, method_name)
      if owner.private_method_defined?(method_name)
        :private
      elsif owner.protected_method_defined?(method_name)
        :protected
      elsif owner.public_method_defined?(method_name)
        :public
      else
        raise ArgumentError, "`#{method_name.inspect}` is not defined"
      end
    end

    # Determine if a method is defined (including private methods)
    # @param owner [Module]
    # @param method_name [Symbol]
    # @return [Boolean]
    def self.method_defined?(owner, method_name)
      owner.method_defined?(method_name) || owner.private_method_defined?(method_name)
    end
  end
end
