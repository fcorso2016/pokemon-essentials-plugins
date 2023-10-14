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

  def initialize(species, level, gender, form, ivs, nature, ability, moves, owner)
    @species = species
    @level = level
    @gender = gender
    @form = form
    @iv = ivs
    @nature = nature
    @ability_index = ability
    @moves = moves
    @owner = owner
  end
end

class MockMap
  attr_reader :name

  def initialize(name)
    @name = name
  end
end

class Trainer
  def initialize(name, trainer_type)
    # This exists just to shut RubyMine up about the constructor arguments being wrong
  end
end