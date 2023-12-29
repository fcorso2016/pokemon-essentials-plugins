class WindowSnagList < Window_DrawableCommand

  def initialize(x, y, width, height, viewport = nil)
    @commands = []
    super(x, y, width, height, viewport)
    @selarrow     = AnimatedBitmap.new("Graphics/UI/Pokedex/cursor_list")
    @pokeball_snagged  = AnimatedBitmap.new("Graphics/UI/Pokedex/icon_own")
    @pokeball_seen = AnimatedBitmap.new("Graphics/UI/Pokedex/icon_seen")
    self.baseColor   = Color.new(88, 88, 80)
    self.shadowColor = Color.new(168, 184, 184)
    self.windowskin  = nil
  end

  def commands=(value)
    @commands = value
    refresh
  end

  def dispose
    @pokeball_snagged.dispose
    @pokeball_seen.dispose
    super
  end

  def species
    return (@commands.length == 0) ? nil : @commands[self.index][:species]
  end

  def itemCount
    return @commands.length
  end

  def drawItem(index, count, rect)
    return if index >= self.top_row + self.page_item_max
    rect = Rect.new(rect.x + 16, rect.y, rect.width - 16, rect.height)
    species = @commands[index][:species]
    if $player.shadow_seen.has_key?(species)
      if $player.shadow_seen[species].snagged
        pbCopyBitmap(self.contents, @pokeball_snagged.bitmap, rect.x - 6, rect.y + 8)
      else
        pbCopyBitmap(self.contents, @pokeball_seen.bitmap, rect.x - 6, rect.y + 8)
      end
      name_text = @commands[index][:name]
    else
      name_text = "----------"
    end
    pbDrawShadowText(self.contents, rect.x + 36, rect.y + 6, rect.width, rect.height,
                     name_text, self.baseColor, self.shadowColor)
  end

  def refresh
    @item_max = itemCount
    dwidth  = self.width - self.borderX.to_int
    dheight = self.height - self.borderY.to_int
    self.contents = pbDoEnsureBitmap(self.contents, dwidth, dheight)
    self.contents.clear
    @item_max.times do |i|
      next if i < self.top_item || i > self.top_item + self.page_item_max
      drawItem(i, @item_max, itemRect(i))
    end
    drawCursor(self.index, itemRect(self.index))
  end

  def update
    super
    @uparrow.visible   = false
    @downarrow.visible = false
  end
end
