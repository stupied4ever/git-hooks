[![Version](http://allthebadges.io/stupied4ever/git-hooks/badge_fury.png)](http://allthebadges.io/stupied4ever/git-hooks/badge_fury)
[![Dependencies](http://allthebadges.io/stupied4ever/git-hooks/gemnasium.png)](http://allthebadges.io/stupied4ever/git-hooks/gemnasium)
[![Build Status](http://allthebadges.io/stupied4ever/git-hooks/travis.png)](http://allthebadges.io/stupied4ever/git-hooks/travis)
[![Coverage](http://allthebadges.io/stupied4ever/git-hooks/coveralls.png)](http://allthebadges.io/stupied4ever/git-hooks/coveralls)
[![Code Climate](http://allthebadges.io/stupied4ever/git-hooks/code_climate.png)](http://allthebadges.io/stupied4ever/git-hooks/code_climate)

# GitHooks

Some usefull git hooks, it's written on ruby but can be used for other languages.

## Installation

Add this line to your application's Gemfile:

    gem 'git-hooks'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install git-hooks

## Usage
### Install git_hooks on project.

```bash
$ git_hooks install pre-commit [--force]
```

### Create configuration file

Create a `.git_hooks.yml` on project root.

```bash
$ git_hooks init
```

By now you will find only some simple hooks to:

 - Prevent commit on master.
 - Prevent commit with rubocop offences.
 - prevent commit with broken rspec tests.
 - prevent commit with debugger

### Ensure hooks existence

To ensure that hooks exists on `.git/hooks`, include on your application
start up (probably  `config/environments/development.rb` or
`config/environments/test.rb`)

```ruby
GitHooks::Validator.validate_all!
```

This will force `git_hooks` installation before your application start.

## Contributing

1. Fork it ( https://github.com/stupied4ever/ruby-git-hooks/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
