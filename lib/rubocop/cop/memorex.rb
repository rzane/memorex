# frozen_string_literal: true

require "rubocop"

module RuboCop
  module Cop
    module Memorex
      class MethodDefinition < RuboCop::Cop::Base
        MSG = "`memoize` should precede a method definition (e.g. `memoize def`)"

        def_node_matcher :invalid_usage?, <<~PATTERN
          (send nil? :memoize (sym _))
        PATTERN

        def on_send(node)
          add_offense(node.selector) if invalid_usage?(node)
        end
      end

      class MethodSignature < RuboCop::Cop::Base
        MSG = "Memoized methods should not accept arguments or yield"

        def_node_matcher :invalid_signature?, <<~PATTERN
          (send nil? :memoize {(def _name (args _+) _body) | (def _name _args `yield)})
        PATTERN

        def on_send(node)
          add_offense(node.selector) if invalid_signature?(node)
        end
      end
    end
  end
end
