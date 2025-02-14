# frozen_string_literal: true

require "rubocop/cop/memox"
require "rubocop/rspec/support"

RSpec.describe RuboCop::Cop::Memox, :config do
  describe RuboCop::Cop::Memox::MethodDefinition do
    it "reports a violation when a symbol is provided" do
      expect_offense(<<~RUBY)
        memoize :foo
        ^^^^^^^ `memoize` should precede a method definition (e.g. `memoize def`)
      RUBY
    end

    it "does not report a violation when memoize is used next to a method definition" do
      expect_no_offenses(<<~RUBY)
        memoize def foo; end
      RUBY
    end
  end

  describe RuboCop::Cop::Memox::MethodSignature do
    it "reports a violation when a method accepts arguments" do
      expect_offense(<<~RUBY)
        memoize def foo(a); end
        ^^^^^^^ Memoized methods should not accept arguments or yield
      RUBY
    end

    it "reports a violation when a method accepts a block" do
      expect_offense(<<~RUBY)
        memoize def foo(&block); end
        ^^^^^^^ Memoized methods should not accept arguments or yield
      RUBY
    end

    it "reports a violation when a method accepts an implicit block" do
      expect_offense(<<~RUBY)
        memoize def foo
        ^^^^^^^ Memoized methods should not accept arguments or yield
          100.times { yield 5 }
        end
      RUBY
    end

    it "does not report a violation for a valid method definition" do
      expect_no_offenses(<<~RUBY)
        def foo(a); end
        def foo(&block); end
        memoize def foo; end
      RUBY
    end
  end
end
