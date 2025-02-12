# frozen_string_literal: true

require_relative "memorex/version"
require_relative "memorex/memory"

module Memorex
  def memoize(method_name)
    visibility = if private_method_defined?(method_name)
      :private
    elsif protected_method_defined?(method_name)
      :protected
    elsif public_method_defined?(method_name)
      :public
    else
      raise ArgumentError, "`#{method_name.inspect}` is not defined"
    end

    @_memorex_methods ||= Module.new.tap { |mod| prepend(mod) }

    if @_memorex_methods.method_defined?(method_name) || @_memorex_methods.private_method_defined?(method_name)
      raise ArgumentError, "`#{method_name.inspect}` is already memoized"
    end

    @_memorex_methods.module_eval(<<~RUBY, __FILE__, __LINE__ + 1)
      #{visibility} def #{method_name}
        raise ArgumentError, "unsupported block argument" if block_given?

        memory = (@_memorex_cache ||= {})
        memory.fetch(:#{method_name}) { memory[:#{method_name}] = super() }
      end
    RUBY

    method_name
  end

  module API
    private def memorex
      ::Memorex::Memory.new(@_memorex_cache ||= {})
    end
  end
end
