# frozen_string_literal: true

require_relative '../test_helper'

$drawn_text = []

def pbDrawShadowText(bitmap, x, y, width, height, string, baseColor, shadowColor = nil, align = 0)
  $drawn_text.push(string)
end

class WindowSnagListTest < Minitest::Test

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
  end

  private

  def create_mock_snag_entry(was_snagged)
    mock = Minitest::Mock.new

    if was_snagged
      def mock.snagged
        return true
      end
    else
      def mock.snagged
        return false
      end
    end

    return mock
  end
end
