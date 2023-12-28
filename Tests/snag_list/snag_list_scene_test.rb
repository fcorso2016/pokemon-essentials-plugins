# frozen_string_literal: true

require_relative '../test_helper'
require_relative 'mocks'

$drawn_text = []
$input_order = []
$cries_played = []

alias draw_shadow_text_snag_list_test pbDrawShadowText
def pbDrawShadowText(bitmap, x, y, width, height, string, baseColor, shadowColor = nil, align = 0)
  draw_shadow_text_snag_list_test(bitmap, x, y, width, height, string, baseColor, shadowColor, align)
  $drawn_text.push(string)
end

module Input
  def self.trigger?(button)
    if $input_order.first == button
      $input_order.delete_at(0)
      return true
    end

    return false
  end

  def self.repeat?(button)
    return self.trigger?(button)
  end
end

module GameData
  class Species
    def self.play_cry_from_species(species)
      if species.is_a?(GameData::Species)
        $cries_played.push(species.id)
      else
        $cries_played.push(species.to_sym)
      end
    end
  end
end

class SnagListSceneTest < Minitest::Test

  def setup
    $player.snag_order.clear
    $player.shadow_seen.clear
    $drawn_text.clear
  end

  def teardown
    $player.snag_order.clear
    $player.shadow_seen.clear
    $drawn_text.clear
  end

  def test_set_commands
    window = WindowSnagList.new(0, 0, 640, 480)
    assert_nil(window.species)

    dummy_commands = [
      {:species => :PIKACHU, :name => "Pikachu"},
      {:species => :ELEKID, :name => "Elekid"},
      {:species => :RAGINGBOLT, :name => "Raging Bolt"}
    ]


    $player.shadow_seen[:PIKACHU] = create_mock_snag_entry(false)
    $player.shadow_seen[:ELEKID] = create_mock_snag_entry(true)

    window.commands = dummy_commands

    assert_equal(["Pikachu", "Elekid", "----------"], $drawn_text)

    window.index = 0
    assert_equal(:PIKACHU, window.species)
    window.index = 1
    assert_equal(:ELEKID, window.species)
    window.index = 2
    assert_equal(:RAGINGBOLT, window.species)
  end

  def test_start_scene
    $player.shadow_seen[:PIKACHU] = create_mock_snag_entry(false)
    $player.shadow_seen[:ELEKID] = create_mock_snag_entry(true)
    $player.snag_order = [:ELEKID, :PIKACHU]

    scene = PokemonSnagListScene.new
    scene.start_scene
    assert_equal(["Elekid", "Pikachu", "Snagged:", "1", "Purified:", "0", "Elekid"], $drawn_text)
  end

  def test_cycle_current_snag_entry
    $player.shadow_seen[:PIKACHU] = create_mock_snag_entry(false)
    $player.shadow_seen[:ELEKID] = create_mock_snag_entry(true)
    $player.snag_order = [:ELEKID, :PIKACHU]

    scene = PokemonSnagListScene.new
    scene.start_scene

    $drawn_text.clear
    $input_order = [Input::DOWN, Input::UP, Input::UP, Input::USE, Input::USE, Input::DOWN, Input::USE, Input::BACK, Input::BACK]
    scene.snag_entry

    assert_equal([:ELEKID, :ELEKID, :PIKACHU, :PIKACHU], $cries_played)
  end

  private

  def create_mock_snag_entry(was_snagged, is_purified = false)
    mock = Minitest::Mock

    if was_snagged
      def mock.snagged
        return true
      end

      def mock.party_poke
        poke_mock = Minitest::Mock.new

        def poke_mock.poke_ball
          return :POKEBALL
        end

        def poke_mock.heart_gauge
          return GameData::ShadowPokemon::HEART_GAUGE_SIZE
        end

        def poke_mock.max_gauge_size
          return GameData::ShadowPokemon::HEART_GAUGE_SIZE
        end

        def poke_mock.heartStage
          max_size = max_gauge_size
          stage_size = max_size / 5.0
          return ([self.heart_gauge, max_size].min / stage_size).ceil
        end

        return poke_mock
      end
    else
      def mock.snagged
        return false
      end

      def mock.party_poke
        return nil
      end
    end

    if is_purified
      def mock.purified
        return true
      end
    else
      def mock.purified
        return false
      end
    end

    def mock.is_a?(type)
      return type == SeenShadowPokemon
    end

    def mock.gender
      return 0
    end

    def mock.form
      return 0
    end

    def mock.location
      return "Fake Area"
    end

    def mock.ot_gender
      return 0
    end

    def mock.ot
      return "Tester"
    end

    return mock
  end
end
