require_relative '../test_helper'
require_relative 'mocks'

TEST_MAP1 = "Intro"

class ShadowPokemonDataTest < Minitest::Test

  def test_snag_index
    global_metadata = MockPokemonGlobalMetadata.new
    assert_equal(0, global_metadata.snag_index)
    global_metadata.snag_index = 2
    assert_equal(2, global_metadata.snag_index)
  end

  def test_shadow_and_snag_order
    mock_owner = MockTrainer.new("Grunt", 1)
    mock_pokemon = MockPokemon.new(:PIKACHU, 25, 0, 0, [31, 31, 31, 31, 31, 31], :MODEST, 0, [:THUNDERBOLT, :QUICKATTACK, :IRONTAIL, :VOLTTACKLE], mock_owner)

    trainer = Trainer.new("Red", :POKEMONTRAINER_Red)
    assert_equal({}, trainer.shadow_seen)
    assert_equal([], trainer.snag_order)

    trainer.register_seen_shadow(mock_pokemon)
    assert_equal(1, trainer.shadow_seen.size)
    assert_equal([:PIKACHU], trainer.snag_order)
    assert_equal(mock_pokemon.level, trainer.shadow_seen[:PIKACHU].level)
    assert_equal(mock_pokemon.gender, trainer.shadow_seen[:PIKACHU].gender)
    assert_equal(mock_pokemon.form, trainer.shadow_seen[:PIKACHU].form)
    assert_equal(mock_pokemon.iv, trainer.shadow_seen[:PIKACHU].iv)
    assert_equal(mock_pokemon.ability_index, trainer.shadow_seen[:PIKACHU].ability)
    assert_equal(mock_pokemon.nature, trainer.shadow_seen[:PIKACHU].nature)
    assert_equal(mock_pokemon.moves, trainer.shadow_seen[:PIKACHU].moves)
    assert_equal(mock_owner.name, trainer.shadow_seen[:PIKACHU].ot)
    assert_equal(mock_owner.gender, trainer.shadow_seen[:PIKACHU].otGender)
    assert_equal(TEST_MAP1, trainer.shadow_seen[:PIKACHU].location)
    assert_equal(false, trainer.shadow_seen[:PIKACHU].snagged)
    assert_equal(false, trainer.shadow_seen[:PIKACHU].purified)
    assert_nil(trainer.shadow_seen[:PIKACHU].party_poke)

    # Adding a the same species does nothing
    mock_owner2 = MockTrainer.new("Joe", 0)
    mock_pokemon2 = MockPokemon.new(:PIKACHU, 10, 1, 3, [24, 21, 24, 8, 14, 31], :ADAMANT, 1, [:THUNDERSHOCK, :GROWL], mock_owner2)
    trainer.register_seen_shadow(mock_pokemon2)
    assert_equal(mock_pokemon.level, trainer.shadow_seen[:PIKACHU].level)
    assert_equal(mock_pokemon.gender, trainer.shadow_seen[:PIKACHU].gender)
    assert_equal(mock_pokemon.form, trainer.shadow_seen[:PIKACHU].form)
    assert_equal(mock_pokemon.iv, trainer.shadow_seen[:PIKACHU].iv)
    assert_equal(mock_pokemon.ability_index, trainer.shadow_seen[:PIKACHU].ability)
    assert_equal(mock_pokemon.nature, trainer.shadow_seen[:PIKACHU].nature)
    assert_equal(mock_pokemon.moves, trainer.shadow_seen[:PIKACHU].moves)
    assert_equal(mock_owner.name, trainer.shadow_seen[:PIKACHU].ot)
    assert_equal(mock_owner.gender, trainer.shadow_seen[:PIKACHU].otGender)
    assert_equal(TEST_MAP1, trainer.shadow_seen[:PIKACHU].location)
    assert_equal(false, trainer.shadow_seen[:PIKACHU].snagged)
    assert_equal(false, trainer.shadow_seen[:PIKACHU].purified)
    assert_nil(trainer.shadow_seen[:PIKACHU].party_poke)

    # Adding a Different Species Though...
    mock_owner = MockTrainer.new("Joe", 0)
    mock_pokemon = MockPokemon.new(:ELEKID, 10, 1, 3, [24, 21, 24, 8, 14, 31], :NAIVE, 1, [:THUNDERSHOCK, :GROWL], mock_owner)
    trainer.register_seen_shadow(mock_pokemon)
    assert_equal(mock_pokemon.level, trainer.shadow_seen[:ELEKID].level)
    assert_equal(mock_pokemon.gender, trainer.shadow_seen[:ELEKID].gender)
    assert_equal(mock_pokemon.form, trainer.shadow_seen[:ELEKID].form)
    assert_equal(mock_pokemon.iv, trainer.shadow_seen[:ELEKID].iv)
    assert_equal(mock_pokemon.ability_index, trainer.shadow_seen[:ELEKID].ability)
    assert_equal(mock_pokemon.nature, trainer.shadow_seen[:ELEKID].nature)
    assert_equal(mock_pokemon.moves, trainer.shadow_seen[:ELEKID].moves)
    assert_equal(mock_owner.name, trainer.shadow_seen[:ELEKID].ot)
    assert_equal(mock_owner.gender, trainer.shadow_seen[:ELEKID].otGender)
    assert_equal(TEST_MAP1, trainer.shadow_seen[:ELEKID].location)
    assert_equal(false, trainer.shadow_seen[:ELEKID].snagged)
    assert_equal(false, trainer.shadow_seen[:ELEKID].purified)
    assert_nil(trainer.shadow_seen[:ELEKID].party_poke)
  end

  def test_register_snag_and_purify
    mock_owner = MockTrainer.new("Grunt", 1)
    mock_pokemon = MockPokemon.new(:PIKACHU, 25, 0, 0, [31, 31, 31, 31, 31, 31], 4, 0, [:THUNDERBOLT, :QUICKATTACK, :IRONTAIL, :VOLTTACKLE], mock_owner)

    trainer = Trainer.new("Red", :POKEMONTRAINER_Red)
    trainer.register_seen_shadow(mock_pokemon)
    assert_equal(false, trainer.shadow_seen[:PIKACHU].snagged)
    assert_equal(false, trainer.shadow_seen[:PIKACHU].purified)
    assert_nil(trainer.shadow_seen[:PIKACHU].party_poke)

    trainer.register_snag(mock_pokemon)
    assert_equal(true, trainer.shadow_seen[:PIKACHU].snagged)
    assert_equal(false, trainer.shadow_seen[:PIKACHU].purified)
    assert_equal(mock_pokemon, trainer.shadow_seen[:PIKACHU].party_poke)

    trainer.register_purification(mock_pokemon)
    assert_equal(true, trainer.shadow_seen[:PIKACHU].snagged)
    assert_equal(true, trainer.shadow_seen[:PIKACHU].purified)
    assert_equal(mock_pokemon, trainer.shadow_seen[:PIKACHU].party_poke)
  end

end