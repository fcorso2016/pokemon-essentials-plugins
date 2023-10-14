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

# This exists just to shut RubyMine up about the constructor arguments being wrong
class Trainer
  def initialize(name, trainer_type)
  end
end

class Battle
  attr_accessor :caughtPokemon

  def initialize(scene, p1, p2, player, opponent)
    @caughtPokemon = []
  end

  def pbMessagesOnBattlerEnteringBattle(battler)

  end

  def pbRecordAndStoreCaughtPokemon
    @caughtPokemon.clear
  end
end