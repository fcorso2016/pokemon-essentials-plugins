class PokemonSnagListScene
  SPECIES_NAME_REGEX = "<ac>{1:s}</ac>"

  def pbUpdate
    pbUpdateSpriteHash(@sprites)
  end

  def setIconBitmap(species)
    gender = ($player.shadowSeen.gender rescue 0)
    form = ($player.shadowSeen.form rescue 0)
    echoln species
    echoln $player.shadowSeen[species]
    @sprites["icon"].setSpeciesBitmap(species, (gender == 1), form, false, !$player.shadowSeen.purified)
  end

  def pbStartScene
    @sliderBitmap = AnimatedBitmap.new("Graphics/UI/Pokedex/icon_slider")
    @typebitmap = AnimatedBitmap.new(_INTL("Graphics/UI/Pokedex/icon_types"))
    @shapebitmap = AnimatedBitmap.new("Graphics/UI/Pokedex/icon_shapes")
    @hwbitmap = AnimatedBitmap.new(_INTL("Graphics/UI/Pokedex/icon_hw"))
    @sprites = {}
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 99999
    addBackgroundPlane(@sprites, "background", "SnagList/bg", @viewport)
    addBackgroundPlane(@sprites, "snagEntry", "SnagList/entry_bg", @viewport)
    @sprites["snagEntry"].visible=false
    @sprites["snagList"] = Window_SnagList.new(206, 30, 276, 364, @viewport)
    @sprites["icon"] = PokemonSprite.new(@viewport)
    @sprites["icon"].setOffset(PictureOrigin::CENTER)
    @sprites["icon"].x = 112
    @sprites["icon"].y = 196
    @sprites["overlay"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
    pbSetSystemFont(@sprites["overlay"].bitmap)
    pbRefreshSnagList($PokemonGlobal.snag_index)
    pbDeactivateWindows(@sprites)
    pbFadeInAndShow(@sprites)
  end

  def pbGetSnagList
    snagList = []
    $player.snagOrder.each do |nationalSpecies|
      snagList.push({:species => nationalSpecies, :name => GameData::Species.get(nationalSpecies).name})
    end
    return snagList
  end

  def pbRefreshSnagList(index = 0)
    @snagOrder = pbGetSnagList
    @sprites["snagList"].commands = @snagOrder
    @sprites["snagList"].index    = index
    @sprites["snagList"].refresh
    pbRefresh
  end

  def pbRefresh
    overlay = @sprites["overlay"].bitmap
    overlay.clear
    base = Color.new(88, 88, 80)
    shadow = Color.new(168, 184, 184)
    iconSpecies = @sprites["snagList"].species
    echoln iconSpecies
    iconSpecies = nil unless $player.shadowSeen[iconSpecies]

    seenNo = 0
    ownedNo = 0
    @snagOrder.each { |i|
      seenNo += 1 if $player.shadowSeen[i].snagged
      ownedNo += 1 if $player.shadowSeen[i].purified
    }
    textPos = [
      [_INTL("Snagged:"), 42, 314, :left, base, shadow],
      [seenNo.to_s, 182, 314, :right, base, shadow],
      [_INTL("Purified:"), 42, 346, :left, base, shadow],
      [ownedNo.to_s, 182, 346, :right, base, shadow]
    ]
    textPos.push([GameData::Species.get(iconSpecies).name, 112, 58, :center, base, shadow]) if iconSpecies

    # Draw all text
    pbDrawTextPositions(overlay, textPos)

    # Set Pokémon sprite
    setIconBitmap(iconSpecies)

    # Draw slider arrows
    itemList = @sprites["snagList"]
    showSlider = false
    if itemList.top_row > 0
      overlay.blt(468, 48, @sliderBitmap.bitmap, Rect.new(0, 0, 40, 30))
      showSlider = true
    end
    if itemList.top_item + itemList.page_item_max < itemList.itemCount
      overlay.blt(468, 346, @sliderBitmap.bitmap, Rect.new(0, 30, 40, 30))
      showSlider = true
    end
    # Draw slider box
    if showSlider
      sliderHeight = 268
      boxHeight = (sliderHeight * itemList.page_row_max / itemList.row_max).floor
      boxHeight += [(sliderHeight - boxHeight) / 2, sliderHeight / 6].min
      boxHeight = [boxHeight.floor, 40].max
      y = 78
      y += ((sliderHeight - boxHeight) * itemList.top_row / (itemList.row_max - itemList.page_row_max)).floor
      overlay.blt(468, y, @sliderBitmap.bitmap, Rect.new(40, 0, 40, 8))
      i = 0
      while i * 16 < boxHeight - 8 - 16
        height = [boxHeight - 8 - 16 - (i * 16), 16].min
        overlay.blt(468, y + 8 + (i * 16), @sliderBitmap.bitmap, Rect.new(40, 8, 40, height))
        i += 1
      end
      overlay.blt(468, y + boxHeight - 16, @sliderBitmap.bitmap, Rect.new(40, 24, 40, 16))
    end
  end

  def pbChangeToSnagEntry(species)
    @sprites["entryicon"] = PokemonSprite.new(@viewport)
    @sprites["entryicon"].setOffset(PictureOrigin::CENTER)
    @sprites["entryicon"].visible = true
    @sprites["snagEntry"].visible = true
    @sprites["overlay"].visible = true
    @sprites["overlay"].bitmap.clear
    overlay = @sprites["overlay"].bitmap
    pokemon = $player.shadowSeen.partyPoke
    imagePos = []
    if pokemon
      ballImage = sprintf("Graphics/UI/Summary/icon_ball_%s", pokemon.poke_ball)
      imagePos.push([ballImage, 14, 60])
    end
    if $player.shadowSeen.purified
      imagePos.push(["Graphics/UI/SnagList/overlay_shadow", 224, 240, 0, 0, -1, -1])
      shadowFract = pokemon.heart_gauge * 1.0 / GameData::ShadowPokemon::HEART_GAUGE_SIZE
      imagePos.push(["Graphics/UI/Summary/overlay_shadowbar", 242, 280, 0, 0, (shadowFract * 248).floor, -1])
    end
    pbDrawImagePositions(overlay, imagePos)
    base = Color.new(248, 248, 248)
    shadow = Color.new(104, 104, 104)
    pbSetSystemFont(overlay)
    speciesname = GameData::Species.get(species).name
    textpos = [
      [speciesname, 50, 68, :left, base, shadow],
      [_ISPRINTF("First Seen"), 238, 86, :left, base, shadow],
      [$player.shadowSeen.location, 435, 118, :center, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [_INTL("Original Trainer"), 238, 150, :left, base, shadow],
      [_INTL("Location"), 238, 214, :left, base, shadow],
      [_parsePokemonLocation(species), 435, 214, :center, Color.new(64, 64, 64), Color.new(176, 176, 176)],
    ]
    textpos.push([_INTL("Heart Gauge"), 238, 246, 0, base, shadow])
    if $player.shadowSeen[species].snagged
      if $player.shadowSeen[species].purified
        heartmessage = _INTL("Successfully overcame all difficult challenges!")
      else
        heartmessage = [_INTL("The door to its heart is open! Undo the final lock!"),
                        _INTL("The door to its heart is almost fully open."),
                        _INTL("The door to its heart is nearly open."),
                        _INTL("The door to its heart is opening wider."),
                        _INTL("The door to its heart is opening up."),
                        _INTL("The door to its heart is tightly shut.")
        ][pokemon.heartStage]
      end
    else
      heartmessage = _INTL("The Pokémon managed to escape capture.")
    end
    memo = sprintf("<c3=404040,B0B0B0>%s\n", heartmessage)
    drawFormattedTextEx(overlay, 234, 308, 276, memo)
    ownerbase = Color.new(64, 64, 64)
    ownershadow = Color.new(176, 176, 176)
    if $player.shadowSeen.otGender == 0 # male OT
      ownerbase = Color.new(24, 112, 216)
      ownershadow = Color.new(136, 168, 208)
    elsif $player.shadowSeen.otGender == 1 # female OT
      ownerbase = Color.new(248, 56, 32)
      ownershadow = Color.new(224, 152, 144)
    end
    textpos.push([$player.shadowSeen.ot, 435, 182, :center, ownerbase, ownershadow])
    if $player.shadowSeen.gender == 0
      textpos.push([_INTL("♂"), 178, 68, 0, Color.new(24, 112, 216), Color.new(136, 168, 208)])
    elsif $player.shadowSeen.gender == 1
      textpos.push([_INTL("♀"), 178, 68, 0, Color.new(248, 56, 32), Color.new(224, 152, 144)])
    end
    pbDrawTextPositions(overlay, textpos)
    gender = $player.shadowSeen.gender
    form = $player.shadowSeen.form
    @sprites["entryicon"].setSpeciesBitmap(species, (gender == 1), form, false, !$player.shadowSeen.purified)
    @sprites["entryicon"].x = 112
    @sprites["entryicon"].y = 196
    GameData::Species.play_cry_from_species(species)
  end

  def pbSnagEntryOnIndex(index)
    oldSprites = pbFadeOutAndHide(@sprites)
    echoln @snagOrder
    pbChangeToSnagEntry(@snagOrder[index][:species])
    pbFadeInAndShow(@sprites)
    curIndex = index
    page = 1
    newPage = 0
    ret = 0
    pbActivateWindow(@sprites, nil) {
      _windowLoop(curIndex, newPage, page, ret)
    }
    $PokemonGlobal.snagIndex = curIndex
    @sprites["snagList"].index = curIndex
    @sprites["snagList"].refresh
    pbFadeInAndShow(@sprites, oldSprites)
  end

  def pbSnagEntry
    pbActivateWindow(@sprites, "snagList") {
      loop do
        Graphics.update
        Input.update
        oldIndex = @sprites["snagList"].index
        pbUpdate
        if oldIndex != @sprites["snagList"].index
          $PokemonGlobal.snagIndex = @sprites["snagList"].index

          iconSpecies = @sprites["snagList"].species
          setIconBitmap(iconSpecies)
          # Update the slider
          yCoord = 62
          if @sprites["snagList"].itemCount > 1
            yCoord += 188.0 * @sprites["snagList"].index / (@sprites["snagList"].itemCount - 1)
          end
          @sprites["slider"].y = yCoord
        end
        if Input.trigger?(Input::B)
          pbPlayCancelSE
          break
        elsif Input.trigger?(Input::A)
          pbPlayDecisionSE
          pbSnagEntryOnIndex(@sprites["snagList"].index)
        end
      end
    }
  end

  def pbEndScene
    pbFadeOutAndHide(@sprites)
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end

  private

  def _parsePokemonLocation(species)
    return "Fled" unless $player.shadowSeen[species].snagged
    $player.party.each do |pkmn|
      return "Party" if _parseEvolutionLine(species, pkmn)
    end
    (0...2).each { |i|
      echoln $PokemonGlobal.day_care[i]
      return "Day Care" if _parseEvolutionLine(species, $PokemonGlobal.day_care[i].pokemon)
    }
    $PokemonStorage.boxes.each do |box|
      box.each do |pkmn|
        return box.name if _parseEvolutionLine(species, pkmn)
      end
    end
    for i in 0...PurifyChamber::NUMSETS
      return "Set #{i + 1}" if _parseEvolutionLine(species, $PokemonGlobal.purifyChamber.getShadow(i))
      $PokemonGlobal.purifyChamber.setList(i).each do |pkmn|
        return "Set #{i + 1}" if _parseEvolutionLine(species, pkmn)
      end
    end
    return "Released"
  end

  def _parseEvolutionLine(original, pkmn)
    return false if pkmn.nil?
    return false unless $player.shadowSeen[original]
    return true if original == pkmn.species
    branches = GameData::Species.get(original).get_evolutions(true)
    branches.each do |evo|
      return true if _parseEvolutionLine(evo[2], pkmn)
    end
    return false
  end

  def _windowLoop(curIndex, newPage, page, ret)
    loop do
      Graphics.update if page == 1
      Input.update
      pbUpdate
      if Input.trigger?(Input::B) || ret == 1
        _onWindowCancel(page)
        break
      elsif Input.trigger?(Input::UP) || ret == 8
        curIndex, newPage = _cursorUp(curIndex, newPage, page)
      elsif Input.trigger?(Input::DOWN) || ret == 2
        curIndex, newPage = _cursorDown(curIndex, newPage, page)
      elsif Input.trigger?(Input::A)
        GameData::Species.play_cry_from_species(@snagOrder[curIndex][:species])
      end
      ret = 0
      if newPage > 0
        page = newPage
        newPage = 0
        @sprites["entryicon"].dispose
        pbChangeToSnagEntry(@snagOrder[curIndex][:species])
      end
    end
  end

  def _cursorDown(curIndex, newPage, page)
    nextIndex = -1
    (curIndex + 1...@snagOrder.length).each { |i|
      if $player.shadowSeen[@snagOrder[i][:species]]
        nextIndex = i
        break
      end
    }
    if nextIndex >= 0
      curIndex = nextIndex
      newPage = page
    end
    pbPlayCursorSE if newPage > 1
    return curIndex, newPage
  end

  def _cursorUp(curIndex, newPage, page)
    nextIndex = -1
    i = curIndex - 1; loop do
      break unless i >= 0
      if $player.shadowSeen[@snagOrder[i][:species]]
        nextIndex = i
        break
      end
      i -= 1
    end
    if nextIndex >= 0
      curIndex = nextIndex
      newPage = page
    end
    pbPlayCursorSE if newPage > 1
    return curIndex, newPage
  end

  def _onWindowCancel(page)
    if page == 1
      pbPlayCancelSE
      pbFadeOutAndHide(@sprites)
    end
    @sprites["entryicon"].dispose
  end
end
