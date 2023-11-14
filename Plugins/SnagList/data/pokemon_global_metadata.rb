class PokemonGlobalMetadata
  attr_writer :snagIndex

  def snagIndex
    return @snagIndex unless @snagIndex.nil?
    @snagIndex = 0
    return @snagIndex
  end
end
