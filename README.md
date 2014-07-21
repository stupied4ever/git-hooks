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

And some simple tasks will be executed such as:
 - ensure hooks exists on ```.git/hooks```

To execute this hooks, you need to:

 - Install git_hooks on project.
 ```git_hooks install pre-commit```

 - Create a ```.git_hooks.yml``` on project root.
 ```
 ---
 pre_commits:
 - GitHooks::PreCommit::PreventMaster
 - GitHooks::PreCommit::Rspec
 - GitHooks::PreCommit::Rubocop
 ```

## Contributing

1. Fork it ( https://github.com/stupied4ever/ruby-git-hooks/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
