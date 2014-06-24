lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'git_hooks/version'

Gem::Specification.new do |spec|
  spec.name          = 'git-hooks'
  spec.version       = GitHooks::VERSION
  spec.authors       = ['Rafael da Silva Almeida']
  spec.email         = ['eusou@rafaelalmeida.net']
  spec.summary       = %q(Help to keep git hooks organized.)
  spec.description   = %q(It stores git hooks and force git hooks installation.)
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)\//)
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
end
