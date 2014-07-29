require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start

require_relative '../lib/git-hooks'

def fixture_path(filename)
  return '' if filename == ''
  File.join(File.absolute_path(File.dirname(__FILE__)), 'fixtures', filename)
end
