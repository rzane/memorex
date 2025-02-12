# frozen_string_literal: true

module Memorex
  module Utils # :nodoc:
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

    def self.method_defined?(owner, method_name)
      owner.method_defined?(method_name) || owner.private_method_defined?(method_name)
    end
  end
end
