class Tilemap

  def initialize(viewport = nil)
    fail NotImplementedError
  end

  def dispose
    fail NotImplementedError
  end

  def disposed?
    fail NotImplementedError
  end

  def update
    fail NotImplementedError
  end

  attr_accessor :tileset

  attr_accessor :autotiles

  attr_accessor :map_data

  attr_accessor :flash_data

  attr_accessor :priorities

  attr_accessor :viewport

  attr_accessor :visible

  attr_accessor :ox

  attr_accessor :oy

end
