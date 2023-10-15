unless $disable_tests
  require 'simplecov' # These two lines must go first
  SimpleCov.start

  require 'minitest/autorun' # Sets up minitest
  require 'spy'

  require_relative '../../../Export/rgss_mocks'
  require_relative '../../../Export/pokemon_essentials'

  require_relative '../src/battle/battle'
  require_relative '../src/data/pokemon_global_metadata'
  require_relative '../src/data/seen_shadow_pokemon'
  require_relative '../src/data/trainer'
  require_relative '../src/ui/menu_handlers'
  require_relative '../src/ui/pokemon_snag_list'
  require_relative '../src/ui/pokemon_snag_list_scene'
  require_relative '../src/ui/window_snag_list'

  require_relative 'mocks'
end