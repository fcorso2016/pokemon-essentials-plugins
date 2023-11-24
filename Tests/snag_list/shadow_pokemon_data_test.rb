require_relative '../test_helper'
require_relative 'mocks'

TEST_MAP1 = "Test Map"
TEST_MAP2 = "Other Map"

class MockPokemonGlobalMetadata < PokemonGlobalMetadata
  def initialize
    # Stub out the constructor to avoid calling a bunch of garbage we don't need
  end
end

class ClassExtensionsTest < Minitest::Test
  def test_snag_index
    global_metadata = MockPokemonGlobalMetadata.new
    assert_equal(0, global_metadata.snag_index)
    global_metadata.snagIndex = 2
    assert_equal(2, global_metadata.snag_index)
  end

  def test_shadow_and_snag_order
    mock_owner = MockTrainer.new("Grunt", 1)
    mock_pokemon = MockPokemon.new(:PIKACHU, 25, 0, 0, [31, 31, 31, 31, 31, 31], 4, 0, [:THUNDERBOLT, :QUICKATTACK, :IRONTAIL, :VOLTTACKLE], mock_owner)
    $game_map = MockMap.new(TEST_MAP1)

    trainer = Trainer.new("Red", :POKEMONTRAINER)
    assert_equal({}, trainer.shadowSeen)
    assert_equal([], trainer.snagOrder)

    trainer.registerSeenShadow(mock_pokemon)
    assert_equal(1, trainer.shadowSeen.size)
    assert_equal([:PIKACHU], trainer.snagOrder)
    assert_equal(25, trainer.shadowSeen[:PIKACHU].level)
    assert_equal(0, trainer.shadowSeen[:PIKACHU].gender)
    assert_equal(0, trainer.shadowSeen[:PIKACHU].form)
    assert_equal([31, 31, 31, 31, 31, 31], trainer.shadowSeen[:PIKACHU].iv)
    assert_equal(0, trainer.shadowSeen[:PIKACHU].ability)
    assert_equal(4, trainer.shadowSeen[:PIKACHU].nature)
    assert_equal([:THUNDERBOLT, :QUICKATTACK, :IRONTAIL, :VOLTTACKLE], trainer.shadowSeen[:PIKACHU].moves)
    assert_equal("Grunt", trainer.shadowSeen[:PIKACHU].ot)
    assert_equal(1, trainer.shadowSeen[:PIKACHU].otGender)
    assert_equal(TEST_MAP1, trainer.shadowSeen[:PIKACHU].location)
    assert_equal(false, trainer.shadowSeen[:PIKACHU].snagged)
    assert_equal(false, trainer.shadowSeen[:PIKACHU].purified)
    assert_nil(trainer.shadowSeen[:PIKACHU].partyPoke)

    # Adding a the same species does nothing
    mock_owner = MockTrainer.new("Joe", 0)
    mock_pokemon = MockPokemon.new(:PIKACHU, 10, 1, 3, [24, 21, 24, 8, 14, 31], 3, 1, [:THUNDERSHOCK, :GROWL], mock_owner)
    $game_map = MockMap.new(TEST_MAP2)
    trainer.registerSeenShadow(mock_pokemon)
    assert_equal(1, trainer.shadowSeen.size)
    assert_equal([:PIKACHU], trainer.snagOrder)
    assert_equal(25, trainer.shadowSeen[:PIKACHU].level)
    assert_equal(0, trainer.shadowSeen[:PIKACHU].gender)
    assert_equal(0, trainer.shadowSeen[:PIKACHU].form)
    assert_equal([31, 31, 31, 31, 31, 31], trainer.shadowSeen[:PIKACHU].iv)
    assert_equal(0, trainer.shadowSeen[:PIKACHU].ability)
    assert_equal(4, trainer.shadowSeen[:PIKACHU].nature)
    assert_equal([:THUNDERBOLT, :QUICKATTACK, :IRONTAIL, :VOLTTACKLE], trainer.shadowSeen[:PIKACHU].moves)
    assert_equal("Grunt", trainer.shadowSeen[:PIKACHU].ot)
    assert_equal(1, trainer.shadowSeen[:PIKACHU].otGender)
    assert_equal(TEST_MAP1, trainer.shadowSeen[:PIKACHU].location)
    assert_equal(false, trainer.shadowSeen[:PIKACHU].snagged)
    assert_equal(false, trainer.shadowSeen[:PIKACHU].purified)
    assert_nil(trainer.shadowSeen[:PIKACHU].partyPoke)

    # Adding a Different Species Though...
    mock_owner = MockTrainer.new("Joe", 0)
    mock_pokemon = MockPokemon.new(:ELEKID, 10, 1, 3, [24, 21, 24, 8, 14, 31], 3, 1, [:THUNDERSHOCK, :GROWL], mock_owner)
    trainer.registerSeenShadow(mock_pokemon)
    assert_equal(2, trainer.shadowSeen.size)
    assert_equal([:PIKACHU, :ELEKID], trainer.snagOrder)
    assert_equal(10, trainer.shadowSeen[:ELEKID].level)
    assert_equal(1, trainer.shadowSeen[:ELEKID].gender)
    assert_equal(3, trainer.shadowSeen[:ELEKID].form)
    assert_equal([24, 21, 24, 8, 14, 31], trainer.shadowSeen[:ELEKID].iv)
    assert_equal(1, trainer.shadowSeen[:ELEKID].ability)
    assert_equal(3, trainer.shadowSeen[:ELEKID].nature)
    assert_equal([:THUNDERSHOCK, :GROWL], trainer.shadowSeen[:ELEKID].moves)
    assert_equal("Joe", trainer.shadowSeen[:ELEKID].ot)
    assert_equal(0, trainer.shadowSeen[:ELEKID].otGender)
    assert_equal(TEST_MAP2, trainer.shadowSeen[:ELEKID].location)
    assert_equal(false, trainer.shadowSeen[:ELEKID].snagged)
    assert_equal(false, trainer.shadowSeen[:ELEKID].purified)
    assert_nil(trainer.shadowSeen[:ELEKID].partyPoke)
  end

  def test_register_snag_and_purify
    mock_owner = MockTrainer.new("Grunt", 1)
    mock_pokemon = MockPokemon.new(:PIKACHU, 25, 0, 0, [31, 31, 31, 31, 31, 31], 4, 0, [:THUNDERBOLT, :QUICKATTACK, :IRONTAIL, :VOLTTACKLE], mock_owner)
    $game_map = MockMap.new(TEST_MAP1)

    trainer = Trainer.new("Red", :POKEMONTRAINER)
    trainer.registerSeenShadow(mock_pokemon)
    assert_equal(false, trainer.shadowSeen[:PIKACHU].snagged)
    assert_equal(false, trainer.shadowSeen[:PIKACHU].purified)
    assert_nil(trainer.shadowSeen[:PIKACHU].partyPoke)

    trainer.registerSnag(mock_pokemon)
    assert_equal(true, trainer.shadowSeen[:PIKACHU].snagged)
    assert_equal(false, trainer.shadowSeen[:PIKACHU].purified)
    assert_equal(mock_pokemon, trainer.shadowSeen[:PIKACHU].partyPoke)

    trainer.registerPurification(mock_pokemon)
    assert_equal(true, trainer.shadowSeen[:PIKACHU].snagged)
    assert_equal(true, trainer.shadowSeen[:PIKACHU].purified)
    assert_equal(mock_pokemon, trainer.shadowSeen[:PIKACHU].partyPoke)
  end
end