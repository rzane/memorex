# frozen_string_literal: true

require_relative "memorex/version"

module Memorex
  def memoize(method_name)
    @_memoize_methods ||= Module.new.tap { |mod| prepend(mod) }

    visibility = if private_method_defined?(method_name)
      :private
    elsif protected_method_defined?(method_name)
      :protected
    else
      :public
    end

    @_memoize_methods.module_eval(<<~RUBY, __FILE__, __LINE__ + 1)
      #{visibility} def #{method_name}
        cache = (@_memoize_cache ||= {})
        cache.fetch(:#{method_name}) { cache[:#{method_name}] = super() }
      end
    RUBY

    method_name
  end
end
