class SeenShadowPokemon
  attr_reader :level
  attr_reader :gender
  attr_reader :form
  attr_reader :iv
  attr_reader :nature
  attr_reader :ability
  attr_reader :moves
  attr_reader :ot
  attr_reader :ot_gender
  attr_reader :location
  attr_reader :snagged
  attr_reader :purified
  attr_reader :party_poke

  def initialize(pokemon, location_name)
    @level = pokemon.level
    @gender = pokemon.gender
    @form = pokemon.form
    @iv = pokemon.iv
    @nature = pokemon.nature
    @ability = pokemon.ability_index
    @moves = pokemon.moves
    @ot = pokemon.owner.name
    @ot_gender = pokemon.owner.gender
    @location = location_name
    @snagged = false
    @purified = false
    @party_poke = nil
  end

  def register_snagged(party_poke)
    @snagged = true
    @party_poke = party_poke
  end

  def register_purified
    @purified = true
  end
end
