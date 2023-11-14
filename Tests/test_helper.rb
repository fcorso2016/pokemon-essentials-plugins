unless $disable_tests
  require 'simplecov' # These two lines must go first
  SimpleCov.start

  require 'minitest/autorun' # Sets up minitest
  require 'spy'

  require 'mkxp-z'
  MKXP_Z.init_game_state('Pokemon Essentials', [], false)

  require_relative '../../../Export/pokemon_essentials'
  require_relative '../lib/snag_list'

  require_relative 'mocks'
end