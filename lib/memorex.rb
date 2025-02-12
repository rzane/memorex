# frozen_string_literal: true

require_relative "memorex/version"

module Memorex
  def memoize(method_name)
    @_memorex_methods ||= Module.new.tap { |mod| prepend(mod) }

    if @_memorex_methods.method_defined?(method_name)
      raise ArgumentError, "`#{method_name.inspect}` is already memoized"
    end

    visibility = if private_method_defined?(method_name)
      :private
    elsif protected_method_defined?(method_name)
      :protected
    elsif public_method_defined?(method_name)
      :public
    else
      raise ArgumentError, "`#{method_name.inspect}` is not a method"
    end

    @_memorex_methods.module_eval(<<~RUBY, __FILE__, __LINE__ + 1)
      #{visibility} def #{method_name}
        cache = (@_memorex_cache ||= {})
        cache.fetch(:#{method_name}) { cache[:#{method_name}] = super() }
      end
    RUBY

    method_name
  end
end
