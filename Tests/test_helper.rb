require 'simplecov' # These two lines must go first
SimpleCov.start

require "simplecov_json_formatter"
SimpleCov.formatter = SimpleCov::Formatter::JSONFormatter

require 'minitest/autorun' # Sets up minitest
require 'spy'