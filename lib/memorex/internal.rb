# frozen_string_literal: true

module Memorex
  # These methods are use internally by Memorex and are not intended for public use.
  # @api private
  module Internal
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
