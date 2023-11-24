class Battle
  alias on_enter_battle_alias_snag_list pbMessagesOnBattlerEnteringBattle
  def pbMessagesOnBattlerEnteringBattle(battler)
    on_enter_battle_alias_snag_list(battler)
    $player.registerSeenShadow(battler.pokemon) if battler.shadowPokemon?
  end

  alias record_and_store_alias_snag_list pbRecordAndStoreCaughtPokemon
  def pbRecordAndStoreCaughtPokemon
    @caughtPokemon.each do |pkmn|
      $player.registerSnag(pkmn) if pkmn.shadowPokemon?
    end
    record_and_store_alias_snag_list
  end
end
