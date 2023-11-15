require 'simplecov' # These two lines must go first
SimpleCov.start

require 'minitest/autorun' # Sets up minitest
require 'spy'

$show_window = false
require_relative '../game_core'

PluginManager.runPlugins