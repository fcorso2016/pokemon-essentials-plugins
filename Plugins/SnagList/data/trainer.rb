class Trainer
  attr_writer :shadow_seen
  attr_writer :snag_order

  def shadow_seen
    return @shadow_seen unless @shadow_seen.nil?
    @shadow_seen = {}
    return @shadow_seen
  end

  def snag_order
    return @snag_order unless @snag_order.nil?
    @snag_order = []
    return @snag_order
  end

  def register_seen_shadow(pokemon)
    # Initialize All Variables if Needed
    shadow_seen
    snag_order
    # Process Info
    return unless @shadow_seen[pokemon.species].nil?
    @shadow_seen[pokemon.species] = SeenShadowPokemon.new(pokemon, $game_map.name)
    @snag_order.push(pokemon.species)
  end

  def register_snag(pokemon)
    return unless @shadow_seen.has_key?(pokemon.species)
    @shadow_seen[pokemon.species].register_snagged(pokemon)
  end

  def register_purification(pokemon)
    return unless @shadow_seen.has_key?(pokemon.species)
    @shadow_seen[pokemon.species].register_purified
  end
end
