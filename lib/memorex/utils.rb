# frozen_string_literal: true

module Memorex
  # @api private
  module Utils
    # Retrieve or define a module named MemorexMethods
    def self.methods_module(owner)
      if owner.const_defined?(:MemorexMethods, false)
        owner.const_get(:MemorexMethods, false)
      else
        Methods.clone.tap do |mod|
          owner.const_set(:MemorexMethods, mod)
          owner.prepend(mod)
        end
      end
    end

    # Determine the visibility of a method
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
    def self.method_defined?(owner, method_name)
      owner.method_defined?(method_name) || owner.private_method_defined?(method_name)
    end
  end
end
