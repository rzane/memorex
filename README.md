# Memorex 🦖

Memorex is a simple solution for caching method return values in Ruby.

Memorex is designed with the following features in mind:

* Fully compatible with Sorbet.
* Support for memoizing methods on frozen objects.
* Support for preloading and resetting memoized values.
* Support for memoization of class and module methods.
* Support for inheritance of memoized class and instance methods.
* No support for memoization of methods with arguments, which is a feature, not a bug.

## Documentation

[Click here to read the documentation.](https://rubydoc.info/gems/memorex/Memorex)

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add memorex
```

## Usage

To memoize a method, simply extend the class with `Memorex` and use the `memoize` decorator.

```ruby
class User
  extend Memorex

  memoize def id
    SecureRandom.uuid
  end
end

user = User.new
user.id # => "ea16e391-20c2-477a-b393-691633a6483f"
user.id # => "ea16e391-20c2-477a-b393-691633a6483f"
```

Memorex can also memoize class methods:

```ruby
class Configuration
  class << self
    extend Memorex

    memoize def instance
      new(YAML.load_file("config.yml"))
    end
  end
end
```

### `Memorex::API`

To access the cache directly, include `Memorex::API`.

```ruby
class User
  extend Memorex
  include Memorex::API
  # ... etc ...
end

user = User.new
user.memorex # => #<Memorex::Memory>

user.memorex.merge!(id: SecureRandom.id)
user.memorex.delete(:id)
user.memorex.clear
```

### `Memorex.reset`

Memorex provides a `reset` method for resetting the cache, but `Memorex::API#clear` should be preferred.

```ruby
user = User.new
user.id # => "ea16e391-20c2-477a-b393-691633a6483f"

Memorex.reset(user)
user.id # => "4690993f-408f-4b7a-824b-c6776782b2fd"
```

## RuboCop

Memorex provides some RuboCop rules to ensure that you're using it correctly.

Add the following configuration to your `.rubocop.yml` file:

```yaml
inherit_gem:
  memorex: config/rubocop.yml
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rzane/memorex.
