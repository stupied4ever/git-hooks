# -*- encoding : utf-8 -*-
require_relative '../lib/git-hooks'

def fixture_path(filename)
  return '' if filename == ''
  File.join(File.absolute_path(File.dirname(__FILE__)), 'fixtures', filename)
end
