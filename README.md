# GitHooks

Some usefull ruby git hooks.

## Installation

Add this line to your application's Gemfile:

    gem 'git-hooks'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install git-hooks

## Usage

By now you will find only some simple hooks to:

 - Prevent commit on master.
 - Prevent commit with rubocop offences.
 - prevent commit with broken rspec tests.

In the future, some validations will be
added, such as:

 - ensure hooks exists on ```.git/hooks```

By now, if you want all this validations, you should include a
```.git/hooks/pre-commit``` with:

```
#!/usr/bin/env ruby
require 'git-hooks'

GitHooks::PreCommit::PreventMaster.validate
GitHooks::PreCommit::Rspec.validate
GitHooks::PreCommit::Rubocop.validate
```

## Contributing

1. Fork it ( https://github.com/stupied4ever/ruby-git-hooks/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
