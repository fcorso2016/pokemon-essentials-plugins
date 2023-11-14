class Trainer
  attr_writer :shadowSeen
  attr_writer :snagOrder

  def shadowSeen
    return @shadowSeen unless @shadowSeen.nil?
    @shadowSeen = {}
    return @shadowSeen
  end

  def snagOrder
    return @snagOrder unless @snagOrder.nil?
    @snagOrder = []
    return @snagOrder
  end

  def registerSeenShadow(pokemon)
    # Initialize All Variables if Needed
    shadowSeen
    snagOrder
    # Process Info
    return unless @shadowSeen[pokemon.species].nil?
    @shadowSeen[pokemon.species] = SeenShadowPokemon.new(pokemon, $game_map.name)
    @snagOrder.push(pokemon.species)
  end

  def registerSnag(pokemon)
    return unless @shadowSeen[pokemon.species]
    @shadowSeen[pokemon.species].registerSnagged(pokemon)
  end

  def registerPurification(pokemon)
    return unless @shadowSeen[pokemon.species]
    @shadowSeen[pokemon.species].registerPurified
  end
end
