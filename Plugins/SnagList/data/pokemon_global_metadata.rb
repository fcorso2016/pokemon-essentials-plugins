class PokemonGlobalMetadata
  attr_writer :snag_index

  def snag_index
    return @snag_index unless @snag_index.nil?
    @snag_index = 0
    return @snag_index
  end
end
