# Memox 📝🐂

Memox is a simple solution for caching method return values in Ruby.

Memox is designed with the following features in mind:

* Fully compatible with Sorbet.
* Support for memoizing methods on frozen objects.
* Support for preloading and resetting memoized values.
* Support for memoization of class and module methods.
* Support for inheritance of memoized class and instance methods.
* No support for memoization of methods with arguments, which is a feature, not a bug.
* Provides RuboCop rules to ensure consistent usage.
* Provides RBI definitions for Sorbet users.
* Provides RBS definitions for Steep users.

## Documentation

[Click here to read the documentation.](https://rubydoc.info/gems/memox/Memox)

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add memox
```

## Usage

To memoize a method, simply extend the class with `Memox` and use the `memoize` decorator.

```ruby
class User
  extend Memox

  memoize def id
    SecureRandom.uuid
  end
end

user = User.new
user.id # => "ea16e391-20c2-477a-b393-691633a6483f"
user.id # => "ea16e391-20c2-477a-b393-691633a6483f"
```

Memox can also memoize class methods:

```ruby
class Configuration
  class << self
    extend Memox

    memoize def instance
      new(YAML.load_file("config.yml"))
    end
  end
end
```

### `Memox::API`

To access the cache directly, include `Memox::API`.

```ruby
class User
  extend Memox
  include Memox::API
  # ... etc ...
end

user = User.new
user.memox # => #<Memox::Cache>

user.memox.merge!(id: SecureRandom.id)
user.memox.delete(:id)
user.memox.clear
```

### `Memox.reset`

Memox provides a `reset` method for resetting the cache, but `Memox::API#clear` should be preferred.

```ruby
user = User.new
user.id # => "ea16e391-20c2-477a-b393-691633a6483f"

Memox.reset(user)
user.id # => "4690993f-408f-4b7a-824b-c6776782b2fd"
```

## RuboCop

Memox provides some RuboCop rules to ensure that you're using it correctly.

Add the following configuration to your `.rubocop.yml` file:

```yaml
inherit_gem:
  memox: config/rubocop.yml
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rzane/memox.
