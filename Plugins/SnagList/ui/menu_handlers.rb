#===============================================================================
# Snag List main screen
#===============================================================================
MenuHandlers.add(:pokegear_menu, :snag_list, {
  "name" => _INTL("Snag List"),
  "icon_name" => "snag_list",
  "order" => 11,
  "condition" => proc { next $player.has_snag_machine && $player.shadowSeen.size > 0 },
  "effect" => proc {
    pbFadeOutIn do
      scene = PokemonSnagListScene.new
      screen = PokemonSnagList.new(scene)
      screen.pbStartScreen
    end
  }
})

