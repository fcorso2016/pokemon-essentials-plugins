class MockTrainer
  attr_reader :name
  attr_reader :gender

  def initialize(name, gender)
    @name = name
    @gender = gender
  end
end

class MockPokemon
  attr_reader :species
  attr_reader :level
  attr_reader :gender
  attr_reader :form
  attr_reader :iv
  attr_reader :nature
  attr_reader :ability_index
  attr_reader :moves
  attr_reader :owner

  def initialize(species, level, gender, form, ivs, nature, ability, moves, owner, shadow = true)
    @species = species
    @level = level
    @gender = gender
    @form = form
    @iv = ivs
    @nature = nature
    @ability_index = ability
    @moves = moves
    @owner = owner
    @shadow = shadow
  end

  def shadowPokemon?
    @shadow
  end
end

class MockBattler
  attr_reader :pokemon

  def initialize(pokemon, shadow)
    @pokemon = pokemon
    @shadowPokemon = shadow
  end

  def shadowPokemon?
    @shadowPokemon
  end

end

class MockMap
  attr_reader :name

  def initialize(name)
    @name = name
  end
end

class GameData::TrainerType
  def self.get(sym)
    mock = Minitest::Mock.new
    def mock.id; return 1; end
    return mock
  end
end

class Battle
  attr_accessor :caughtPokemon

  def record_and_store_alias_snag_list
    # We need to stub this method out because it invokes a lot of functionality we don't care for
    @caughtPokemon.clear
  end
end

class MockPokemonGlobalMetadata < PokemonGlobalMetadata
  def initialize
    # Stub out the constructor to avoid calling a bunch of garbage we don't need
  end
end