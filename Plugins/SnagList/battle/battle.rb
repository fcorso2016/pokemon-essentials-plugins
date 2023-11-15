class Battle
  alias onEnterBattle_SnagList pbMessagesOnBattlerEnteringBattle
  def pbMessagesOnBattlerEnteringBattle(battler)
    onEnterBattle_SnagList(battler)
    $player.registerSeenShadow(battler.pokemon) if battler.shadowPokemon?
  end

  alias recordAndStore_SnagList pbRecordAndStoreCaughtPokemon
  def pbRecordAndStoreCaughtPokemon
    @caughtPokemon.each do |pkmn|
      $player.registerSnag(pkmn) if pkmn.shadowPokemon?
    end
    recordAndStore_SnagList
  end
end
