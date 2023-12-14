# frozen_string_literal: true

require_relative '../test_helper'

class PokegearHandlerTest < Minitest::Test
  def before_setup
    $show_window = false
    require_relative '../../game_core'

    PluginManager.runPlugins
    Compiler.main
    Game.initialize
    Game.set_up_system
    SaveData.load_new_game_values
  end

  def setup
    @sample_pokemon = Pokemon.new(:PIKACHU, 24)
  end

  def test_scene_condition_both_invalid
    $player.has_snag_machine = false
    $player.shadow_seen = {}
    assert(MenuHandlers.call(:pokegear_menu, :snag_list, "condition"))
  end

  def test_scene_condition_no_snag_machine
    $player.has_snag_machine = false
    $player.shadow_seen = {:PIKACHU => SeenShadowPokemon.new(@sample_pokemon, "test") }
    assert(MenuHandlers.call(:pokegear_menu, :snag_list, "condition"))
  end

  def test_scene_condition_no_shadow_seen
    $player.has_snag_machine = true
    $player.shadow_seen = {}
    assert(MenuHandlers.call(:pokegear_menu, :snag_list, "condition"))
  end

  def test_scene_condition_valid
    $player.has_snag_machine = true
    $player.shadow_seen = {:PIKACHU => SeenShadowPokemon.new(@sample_pokemon, "test") }
    assert(MenuHandlers.call(:pokegear_menu, :snag_list, "condition"))
  end

  def test_effect_code
    $player.shadow_seen = {:PIKACHU => SeenShadowPokemon.new(@sample_pokemon, "test") }
    $player.snag_order = [:PIKACHU]
    $window_activated = false
    require_relative 'mocks/mock_active_window'
    MenuHandlers.call(:pokegear_menu, :snag_list, "effect")
    assert($window_activated)
  end
end
