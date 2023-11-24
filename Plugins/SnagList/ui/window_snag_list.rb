class WindowSnagList < Window_Pokedex
  def drawItem(index, count, rect)
    return if index >= self.top_row + self.page_item_max
    rect = Rect.new(rect.x + 16, rect.y, rect.width - 16, rect.height)
    echoln @commands[index]
    species = @commands[index][:species]
    if $player.shadow_seen[species]
      if $player.shadow_seen[species].snagged
        pbCopyBitmap(self.contents, @pokeballOwn.bitmap, rect.x - 6, rect.y + 8)
      else
        pbCopyBitmap(self.contents, @pokeballSeen.bitmap, rect.x - 6, rect.y + 8)
      end
      name_text = @commands[index][:name]
    else
      name_text = "----------"
    end
    pbDrawShadowText(self.contents, rect.x + 36, rect.y + 6, rect.width, rect.height,
                     name_text, self.baseColor, self.shadowColor)
  end
end
