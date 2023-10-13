class Pokemon
  attr_writer :snagged

  def snagged
    return @snagged unless @snagged.nil?
    @snagged = false
    return @snagged
  end
end
