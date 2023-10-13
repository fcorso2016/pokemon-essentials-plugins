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
    echoln pokemon.species
    return unless @shadowSeen[pokemon.species].nil?
    @shadowSeen[pokemon.species] = {}
    @shadowSeen[pokemon.species][:level] = pokemon.level
    @shadowSeen[pokemon.species][:gender] = pokemon.gender
    @shadowSeen[pokemon.species][:form] = pokemon.form
    @shadowSeen[pokemon.species][:iv] = pokemon.iv
    @shadowSeen[pokemon.species][:nature] = pokemon.nature
    @shadowSeen[pokemon.species][:ability] = pokemon.ability_index
    @shadowSeen[pokemon.species][:moves] = pokemon.moves
    @shadowSeen[pokemon.species][:ot] = pokemon.owner.name
    @shadowSeen[pokemon.species][:otgender] = pokemon.owner.gender
    @shadowSeen[pokemon.species][:location] = $game_map.name
    @shadowSeen[pokemon.species][:snagged] = false
    @shadowSeen[pokemon.species][:purified] = false
    @shadowSeen[pokemon.species][:partyPoke] = nil
    @snagOrder.push(pokemon.species)

    echoln @shadowSeen
    echoln @snagOrder
  end

  def registerSnag(pokemon)
    return unless @shadowSeen[pokemon.species]
    @shadowSeen[pokemon.species][:snagged] = true
    @shadowSeen[pokemon.species][:partyPoke] = pokemon

    echoln @shadowSeen
  end

  def registerPurification(pokemon)
    return unless @shadowSeen[pokemon.species]
    @shadowSeen[pokemon.species][:snagged] = true
    @shadowSeen[pokemon.species][:purified] = true
    @shadowSeen[pokemon.species][:partyPoke] = pokemon
  end
end
