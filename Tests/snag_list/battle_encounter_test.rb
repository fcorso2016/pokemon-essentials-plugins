require_relative '../test_helper'

  class BattleEncounterTest < Minitest::Test
    def before_setup
      $show_window = false
      require_relative '../../game_core'

      $DEBUG = true
      PluginManager.runPlugins
      Compiler.main
      Game.initialize
      Game.set_up_system
      Game.start_new
      require_relative 'mocks'
    end

    def setup
      mock_poke1 = Minitest::Mock.new
      def mock_poke1.item_id; return 0; end
      mock_poke2 = Minitest::Mock.new
      def mock_poke2.item_id; return 0; end

      @battle = Battle.new(nil, [mock_poke1], [mock_poke2], nil, nil)
      @battle.caughtPokemon.clear
      $player.snag_order.clear
      $player.shadow_seen.clear
    end

    def teardown
      @battle.caughtPokemon.clear
      $player.snag_order.clear
      $player.shadow_seen.clear
    end

    def test_on_battle_entry_without_shadow
      mock_owner = MockTrainer.new("Grunt", 1)
      mock_pokemon = MockPokemon.new(:PIKACHU, 25, 0, 0, [31, 31, 31, 31, 31, 31], 4, 0, [:THUNDERBOLT, :QUICKATTACK, :IRONTAIL, :VOLTTACKLE], mock_owner)
      mock_battler = MockBattler.new(mock_pokemon, false)

      battle_spy = Spy.on(@battle, :on_enter_battle_alias_snag_list)
      @battle.pbMessagesOnBattlerEnteringBattle(mock_battler)
      assert(battle_spy.has_been_called?)
      assert_equal([], $player.snag_order)
    end

    def test_on_battle_entry_with_shadow
      mock_owner = MockTrainer.new("Grunt", 1)
      mock_pokemon = MockPokemon.new(:PIKACHU, 25, 0, 0, [31, 31, 31, 31, 31, 31], 4, 0, [:THUNDERBOLT, :QUICKATTACK, :IRONTAIL, :VOLTTACKLE], mock_owner)
      mock_battler = MockBattler.new(mock_pokemon, true)

      battle_spy = Spy.on(@battle, :on_enter_battle_alias_snag_list)
      @battle.pbMessagesOnBattlerEnteringBattle(mock_battler)
      assert(battle_spy.has_been_called?)
      assert_equal([:PIKACHU], $player.snag_order)
    end

    def test_caught_pokemon_add
      mock_owner = MockTrainer.new("Grunt", 1)
      mock_pokemon1 = MockPokemon.new(:PIKACHU, 25, 0, 0, [31, 31, 31, 31, 31, 31], 4, 0, [:THUNDERBOLT, :QUICKATTACK, :IRONTAIL, :VOLTTACKLE], mock_owner)
      mock_pokemon2 = MockPokemon.new(:ELEKID, 10, 1, 3, [24, 21, 24, 8, 14, 31], 3, 1, [:THUNDERSHOCK, :GROWL], mock_owner, false)
      $player.register_seen_shadow(mock_pokemon1)
      assert(!$player.shadow_seen[:PIKACHU].snagged)
      assert_nil($player.shadow_seen[:PIKACHU].party_poke)

      @battle.caughtPokemon = [mock_pokemon1, mock_pokemon2]
      @battle.pbRecordAndStoreCaughtPokemon
      assert_empty(@battle.caughtPokemon)
      assert($player.shadow_seen[:PIKACHU].snagged)
      assert_equal(mock_pokemon1, $player.shadow_seen[:PIKACHU].party_poke)
    end
  end