[![Version](http://allthebadges.io/stupied4ever/git-hooks/badge_fury.png)](http://allthebadges.io/stupied4ever/git-hooks/badge_fury)
[![Dependencies](http://allthebadges.io/stupied4ever/git-hooks/gemnasium.png)](http://allthebadges.io/stupied4ever/git-hooks/gemnasium)
[![Build Status](http://allthebadges.io/stupied4ever/git-hooks/travis.png)](http://allthebadges.io/stupied4ever/git-hooks/travis)
[![Coverage](http://allthebadges.io/stupied4ever/git-hooks/coveralls.png)](http://allthebadges.io/stupied4ever/git-hooks/coveralls)
[![Code Climate](http://allthebadges.io/stupied4ever/git-hooks/code_climate.png)](http://allthebadges.io/stupied4ever/git-hooks/code_climate)

# GitHooks

This gem provides an interface to write useful git hooks in Ruby. Those hooks
can be used when working in projects in any programming language.

## Installation

Add this line to your application's `Gemfile`:

    gem 'git-hooks'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install git-hooks

## Usage
### Install git_hooks on your project.

```bash
$ cd /path/to/project
$ git_hooks install pre-commit [--force]
```

### Create configuration file

Create a `.git_hooks.yml` on project root.

```bash
$ cd /path/to/project
$ git_hooks init
```

By now you will find the following built-in hooks:

 - Prevent commits on master branch.
 - Prevent commits with rubocop offenses.
 - Prevent commits with broken rspec tests.
 - Prevent commits with debugger.
 - Prevent commits with trailing white space.

### Warning about `Rubocop` pre-commit `use_stash` option:

This feature is yet experimental. Be aware that in some odd circumstances you
may encounter merge conflicts when applying the stash.

### Ensure hooks existence

To ensure that hooks exists on `.git/hooks`, include the following line on your
application's start-up code (e.g. `config/environments/development.rb` or
`config/environments/test.rb` for a rails app).

```ruby
GitHooks.validate_hooks!
```

This will force `git_hooks` installation before you can run your application. Be
sure not to call `GitHooks#validate_hooks!` on production environments though!

### Problems with ruby version

If you run `git` under other systems such as `gitk` or Emacs' `Magit`, you may
encounter problems with the ruby version being used to run `GitHooks`. This
happens because those applications don't source the `~/.bashrc` file, which is
required by ruby version managers such as `Rbenv` and `Rvm`.

In order to fix this problem, you can install the hooks by passing your ruby
path to the `--ruby_path` option. For example:

```sh
$ git_hooks install pre-commit --ruby_path `which ruby`
```

You can also manually edit the `.git/hooks/{hook-name}` file though.

## Contributing

1. Fork it ( https://github.com/stupied4ever/ruby-git-hooks/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
