# frozen_string_literal: true

module Memorex
  # These methods are use internally by Memorex and are not intended for public use.
  # @api private
  module Internal
    # Lookup or define a module named MemorexMethods
    # @param owner [Module]
    # @return [Module]
    def self.methods_module(owner)
      if owner.const_defined?(:MemorexMethods, false)
        owner.const_get(:MemorexMethods, false)
      else
        owner.const_set(:MemorexMethods, Module.new).tap { |mod| owner.prepend(mod) }
      end
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
