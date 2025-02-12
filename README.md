# Memorex 🦖

Memorex is a simple solution for caching method return values in Ruby.

Memorex is designed with the following features in mind:

* Works with Sorbet signatures.
* Works with frozen objects.
* Returns a Symbol, so you can chain decorators.
* Doesn't memoize methods with arguments, which is a feature, not a bug.

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add memorex
```

## Usage

To memoize a method, simply extend the class with `Memorex` and use the `memoize` decorator.

```ruby
class Client
  extend Memorex

  memoize def response
    Net::HTTP.get(URI('https://example.com'))
  end
end

client = Client.new
client.response # => "<!doctype html>..."
```

Memorex also provides an API for directly manipulating the cache.

```ruby
class Client
  extend Memorex
  include Memorex::API
  # ... etc ...
end

client = Client.new

# Add values to the cache
client.memorex.merge!(response: "hello")

# Remove a value from the cache
client.memorex.delete(:response)

# Clear the cache
client.memorex.clear
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/memorex.
