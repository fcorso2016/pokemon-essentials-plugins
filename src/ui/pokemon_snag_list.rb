class PokemonSnagList
  def initialize(scene)
    @scene = scene
  end

  def pbStartScreen
    @scene.pbStartScene
    @scene.pbSnagEntry
    @scene.pbEndScene
  end
end
