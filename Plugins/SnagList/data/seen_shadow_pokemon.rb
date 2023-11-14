class SeenShadowPokemon
  attr_reader :level
  attr_reader :gender
  attr_reader :form
  attr_reader :iv
  attr_reader :nature
  attr_reader :ability
  attr_reader :moves
  attr_reader :ot
  attr_reader :otGender
  attr_reader :location
  attr_reader :snagged
  attr_reader :purified
  attr_reader :partyPoke

  def initialize(pokemon, locationName)
    @level = pokemon.level
    @gender = pokemon.gender
    @form = pokemon.form
    @iv = pokemon.iv
    @nature = pokemon.nature
    @ability = pokemon.ability_index
    @moves = pokemon.moves
    @ot = pokemon.owner.name
    @otGender = pokemon.owner.gender
    @location = locationName
    @snagged = false
    @purified = false
    @partyPoke = nil
  end

  def registerSnagged(partyPoke)
    @snagged = true
    @partyPoke = partyPoke
  end

  def registerPurified
    @purified = true
  end
end
