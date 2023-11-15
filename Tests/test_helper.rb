require 'simplecov' # These two lines must go first
SimpleCov.start

require 'minitest/autorun' # Sets up minitest
require 'spy'

$show_window = true
require_relative '../game_core'

PluginManager.runPlugins