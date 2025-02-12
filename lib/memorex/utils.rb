# frozen_string_literal: true

module Memorex
  # @api private
  module Utils
    # Determine the visibility of a method
    # @return [Symbol]
    # @raise [ArgumentError] when the method is not defined
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
    # @return [Boolean]
    def self.method_defined?(owner, method_name)
      owner.method_defined?(method_name) || owner.private_method_defined?(method_name)
    end
  end
end
