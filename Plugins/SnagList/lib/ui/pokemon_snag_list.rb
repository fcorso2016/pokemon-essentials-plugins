class PokemonSnagList
  def initialize(scene)
    @scene = scene
  end

  def start_screen
    @scene.start_scene
    @scene.snag_entry
    @scene.end_scene
  end
end
