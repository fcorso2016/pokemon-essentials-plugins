require 'simplecov' # These two lines must go first
SimpleCov.start

require "simplecov_json_formatter"
SimpleCov.formatter = SimpleCov::Formatter::JSONFormatter

require 'minitest/autorun' # Sets up minitest
require 'spy'

$show_window = false
require_relative '../game_core'

$DEBUG = true
PluginManager.runPlugins
Compiler.main
Game.initialize
Game.set_up_system
Game.start_new