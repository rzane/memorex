# frozen_string_literal: true

require "rubocop"

module RuboCop
  module Cop
    # Memorex includes a set of RuboCop rules that encourage best practices when using
    # memorex.
    #
    # Add the following configuration to your `.rubocop.yml`:
    #
    # @example
    #   inherit_gem:
    #     memorex: config/rubocop.yml
    #
    module Memorex
      # This cop checks for memoized methods that accept arguments or yield.
      #
      # @example
      #   # bad
      #   def foo; end
      #   memoize :foo
      #
      #   # good
      #   memoize def foo; end
      class MethodDefinition < RuboCop::Cop::Base
        # @return [String]
        MSG = "`memoize` should precede a method definition (e.g. `memoize def`)"

        def_node_matcher :invalid_usage?, <<~PATTERN
          (send nil? :memoize (sym _))
        PATTERN

        # @!visibility private
        def on_send(node)
          add_offense(node.selector) if invalid_usage?(node)
        end
      end

      # This cop checks for memoized methods that accept arguments or yield.
      #
      # @example
      #   # bad
      #   memoize def foo(a); end
      #
      #   # good
      #   memoize def foo; end
      class MethodSignature < RuboCop::Cop::Base
        # @return [String]
        MSG = "Memoized methods should not accept arguments or yield"

        def_node_matcher :invalid_signature?, <<~PATTERN
          (send nil? :memoize {(def _name (args _+) _body) | (def _name _args `yield)})
        PATTERN

        # @!visibility private
        def on_send(node)
          add_offense(node.selector) if invalid_signature?(node)
        end
      end
    end
  end
end
