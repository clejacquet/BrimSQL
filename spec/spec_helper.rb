$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require 'simplecov'

SimpleCov.start do
  add_filter '/bin/'
  add_filter '/data_sample/'
  add_filter '/spec/'
  add_group 'Library', 'lib'
end if ENV["COVERAGE"]
