require 'minitest/autorun'
require 'spy'
require_relative 'test_utils'

require_relative '../src/battle/battle'
require_relative '../src/data/trainer'
require_relative '../src/data/seen_shadow_pokemon'

class BattleEncounterTest < Minitest::Test
  def setup
    $player = Trainer.new("Red", :POKEMONTRAINER)
    $game_map = MockMap.new("Test Map")
    @battle = Battle.new(nil, nil, nil, nil, nil)
  end

  def teardown
    @battle.caughtPokemon.clear
  end

  def test_on_battle_entry_without_shadow
    mock_owner = MockTrainer.new("Grunt", 1)
    mock_pokemon = MockPokemon.new(:PIKACHU, 25, 0, 0, [31, 31, 31, 31, 31, 31], 4, 0, [:THUNDERBOLT, :QUICKATTACK, :IRONTAIL, :VOLTTACKLE], mock_owner)
    mock_battler = MockBattler.new(mock_pokemon, false)

    battle_spy = Spy.on(@battle, :onEnterBattle_SnagList)
    @battle.pbMessagesOnBattlerEnteringBattle(mock_battler)
    assert(battle_spy.has_been_called?)
    assert_equal([], $player.snagOrder)
  end

  def test_on_battle_entry_with_shadow
    mock_owner = MockTrainer.new("Grunt", 1)
    mock_pokemon = MockPokemon.new(:PIKACHU, 25, 0, 0, [31, 31, 31, 31, 31, 31], 4, 0, [:THUNDERBOLT, :QUICKATTACK, :IRONTAIL, :VOLTTACKLE], mock_owner)
    mock_battler = MockBattler.new(mock_pokemon, true)

    battle_spy = Spy.on(@battle, :onEnterBattle_SnagList)
    @battle.pbMessagesOnBattlerEnteringBattle(mock_battler)
    assert(battle_spy.has_been_called?)
    assert_equal([:PIKACHU], $player.snagOrder)
  end

  def test_caught_pokemon_add
    mock_owner = MockTrainer.new("Grunt", 1)
    mock_pokemon1 = MockPokemon.new(:PIKACHU, 25, 0, 0, [31, 31, 31, 31, 31, 31], 4, 0, [:THUNDERBOLT, :QUICKATTACK, :IRONTAIL, :VOLTTACKLE], mock_owner)
    mock_pokemon2 = MockPokemon.new(:ELEKID, 10, 1, 3, [24, 21, 24, 8, 14, 31], 3, 1, [:THUNDERSHOCK, :GROWL], mock_owner, false)
    $player.registerSeenShadow(mock_pokemon1)
    assert(!$player.shadowSeen[:PIKACHU].snagged)
    assert_nil($player.shadowSeen[:PIKACHU].partyPoke)

    @battle.caughtPokemon = [mock_pokemon1, mock_pokemon2]
    @battle.pbRecordAndStoreCaughtPokemon
    assert_empty(@battle.caughtPokemon)
    assert($player.shadowSeen[:PIKACHU].snagged)
    assert_equal(mock_pokemon1, $player.shadowSeen[:PIKACHU].partyPoke)
  end
end
