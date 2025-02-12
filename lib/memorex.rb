# frozen_string_literal: true

require_relative "memorex/memory"
require_relative "memorex/utils"
require_relative "memorex/version"

module Memorex
  def memoize(method_name)
    visibility = Utils.visibility(self, method_name)

    @_memorex_methods ||= Module.new.tap { |mod| prepend(mod) }

    if Utils.method_defined?(@_memorex_methods, method_name)
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
