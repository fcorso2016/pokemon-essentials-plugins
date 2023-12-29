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
    @iv = convert_ivs(ivs)
    @nature = nature
    @ability_index = ability
    @moves = convert_moves(moves)
    @owner = owner
    @shadow = shadow
  end

  def shadowPokemon?
    @shadow
  end

  private
  def convert_ivs(ivs)
    # @type var ret: Hash[Symbol, Integer]
    ret = {}
    index = 0
    GameData::Stat.each_main do |stat|
      ret[stat.id] = ivs[index]
      index += 1
    end

    return ret
  end

  def convert_moves(moves)
    return moves.map {|id| next Pokemon::Move.new(id) }
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