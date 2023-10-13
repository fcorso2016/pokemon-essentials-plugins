module Battle::CatchAndStoreMixin
  # Register all caught Pokémon in the Pokédex, and store them.
  alias recordAndStore_SnagList pbRecordAndStoreCaughtPokemon

  def pbRecordAndStoreCaughtPokemon
    @caughtPokemon.each do |pkmn|
      pkmn.snagged = true
    end
    recordAndStore_SnagList
  end
end
