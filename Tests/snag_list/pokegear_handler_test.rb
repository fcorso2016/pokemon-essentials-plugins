# frozen_string_literal: true

require_relative '../test_helper'

$window_activated = false

def pbActivateWindow(sprites, key)
  $window_activated = true
end

class PokegearHandlerTest < Minitest::Test

  def setup
    @sample_pokemon = Pokemon.new(:PIKACHU, 24)
  end

  def test_scene_condition_both_invalid
    $player.has_snag_machine = false
    $player.shadow_seen = {}
    assert(!MenuHandlers.call(:pokegear_menu, :snag_list, "condition"))
  end

  def test_scene_condition_no_snag_machine
    $player.has_snag_machine = false
    $player.shadow_seen = {:PIKACHU => SeenShadowPokemon.new(@sample_pokemon, "test") }
    assert(!MenuHandlers.call(:pokegear_menu, :snag_list, "condition"))
  end

  def test_scene_condition_no_shadow_seen
    $player.has_snag_machine = true
    $player.shadow_seen = {}
    assert(!MenuHandlers.call(:pokegear_menu, :snag_list, "condition"))
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
    MenuHandlers.call(:pokegear_menu, :snag_list, "effect")
    assert($window_activated)
  end
end
