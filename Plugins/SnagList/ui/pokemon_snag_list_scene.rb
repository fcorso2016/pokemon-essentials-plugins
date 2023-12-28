class PokemonSnagListScene

  def update
    pbUpdateSpriteHash(@sprites)
  end

  def set_icon_bitmap(species)
    gender = ($player.shadow_seen[species].gender rescue 0)
    form = ($player.shadow_seen[species].form rescue 0)
    @sprites["icon"].setSpeciesBitmap(species, gender, form, false, !$player.shadow_seen[species].purified)
  end

  def start_scene
    @slider_bitmap = AnimatedBitmap.new("Graphics/UI/Pokedex/icon_slider")
    @type_bitmap = AnimatedBitmap.new(_INTL("Graphics/UI/Pokedex/icon_types"))
    @shape_bitmap = AnimatedBitmap.new("Graphics/UI/Pokedex/icon_shapes")
    @hw_bitmap = AnimatedBitmap.new(_INTL("Graphics/UI/Pokedex/icon_hw"))
    @sprites = {}
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 99999
    addBackgroundPlane(@sprites, "background", "SnagList/bg", @viewport)
    addBackgroundPlane(@sprites, "snagEntry", "SnagList/entry_bg", @viewport)
    @sprites["snagEntry"].visible=false
    @sprites["snagList"] = WindowSnagList.new(206, 30, 276, 364, @viewport)
    @sprites["icon"] = PokemonSprite.new(@viewport)
    @sprites["icon"].setOffset(PictureOrigin::CENTER)
    @sprites["icon"].x = 112
    @sprites["icon"].y = 196
    @sprites["overlay"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
    pbSetSystemFont(@sprites["overlay"].bitmap)
    refresh_snag_list($PokemonGlobal.snag_index)
    pbDeactivateWindows(@sprites)
    pbFadeInAndShow(@sprites)
  end

  def snag_entry
    pbActivateWindow(@sprites, "snagList") {
      loop do
        Graphics.update
        Input.update
        old_index = @sprites["snagList"].index
        update
        if old_index != @sprites["snagList"].index
          $PokemonGlobal.snag_index = @sprites["snagList"].index

          icon_species = @sprites["snagList"].species
          set_icon_bitmap(icon_species)
        end
        if Input.trigger?(Input::BACK)
          pbPlayCancelSE
          break
        elsif Input.trigger?(Input::USE)
          pbPlayDecisionSE
          snag_entry_on_index(@sprites["snagList"].index)
        end
      end
    }
  end

  def end_scene
    pbFadeOutAndHide(@sprites)
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end

  private

  def get_snag_list
    # @type var snag_list: Array[snag_entry]
    snag_list = []
    $player.snag_order.each do |nationalSpecies|
      snag_list.push({:species => nationalSpecies, :name => GameData::Species.get(nationalSpecies).name})
    end
    return snag_list
  end

  def refresh_snag_list(index = 0)
    @snag_order = get_snag_list
    @sprites["snagList"].commands = @snag_order
    @sprites["snagList"].index    = index
    refresh
  end

  def refresh
    overlay = @sprites["overlay"].bitmap
    overlay.clear
    base = Color.new(88, 88, 80)
    shadow = Color.new(168, 184, 184)
    icon_species = @sprites["snagList"].species
    icon_species = nil unless icon_species.is_a?(Symbol) && $player.shadow_seen[icon_species]

    seen_no = 0
    owned_no = 0
    @snag_order.each { |entry|
      seen_no += 1 if $player.shadow_seen[entry[:species]].snagged
      owned_no += 1 if $player.shadow_seen[entry[:species]].purified
    }
    # @type var text_pos: Array[text_position]
    text_pos = [
      [_INTL("Snagged:"), 42, 314, :left, base, shadow],
      [seen_no.to_s, 182, 314, :right, base, shadow],
      [_INTL("Purified:"), 42, 346, :left, base, shadow],
      [owned_no.to_s, 182, 346, :right, base, shadow]
    ]
    text_pos.push([GameData::Species.get(icon_species).name, 112, 58, :center, base, shadow]) if icon_species.is_a?(Symbol)

    # Draw all text
    pbDrawTextPositions(overlay, text_pos)

    # Set Pokémon sprite
    set_icon_bitmap(icon_species)

    # Draw slider arrows
    item_list = @sprites["snagList"]
    show_slider = false
    if item_list.top_row > 0
      overlay.blt(468, 48, @slider_bitmap.bitmap, Rect.new(0, 0, 40, 30))
      show_slider = true
    end
    if item_list.top_item + item_list.page_item_max < item_list.itemCount
      overlay.blt(468, 346, @slider_bitmap.bitmap, Rect.new(0, 30, 40, 30))
      show_slider = true
    end
    # Draw slider box
    if show_slider
      slider_height = 268
      box_height = (slider_height * item_list.page_row_max / item_list.row_max).floor
      box_height += [(slider_height - box_height) / 2, slider_height / 6].min || 0
      box_height = [box_height.floor, 40].max || 0
      y = 78
      y += ((slider_height - box_height) * item_list.top_row / (item_list.row_max - item_list.page_row_max)).floor
      overlay.blt(468, y, @slider_bitmap.bitmap, Rect.new(40, 0, 40, 8))
      i = 0
      while i * 16 < box_height - 8 - 16
        # @type var height: Integer
        height = [box_height - 8 - 16 - (i * 16), 16].min || 0
        overlay.blt(468, y + 8 + (i * 16), @slider_bitmap.bitmap, Rect.new(40, 8, 40, height))
        i += 1
      end
      overlay.blt(468, y + box_height - 16, @slider_bitmap.bitmap, Rect.new(40, 24, 40, 16))
    end
  end

  def change_to_snag_entry(species)
    @sprites["entryicon"] = PokemonSprite.new(@viewport)
    @sprites["entryicon"].setOffset(PictureOrigin::CENTER)
    @sprites["entryicon"].visible = true
    @sprites["snagEntry"].visible = true
    @sprites["overlay"].visible = true
    @sprites["overlay"].bitmap.clear
    overlay = @sprites["overlay"].bitmap
    pokemon = $player.shadow_seen[species].party_poke
    # @type var image_pos: Array[image_position]
    image_pos = []
    if pokemon
      ball_image = sprintf("Graphics/UI/Summary/icon_ball_%s", pokemon.poke_ball)
      image_pos.push([ball_image, 14, 60])

      unless $player.shadow_seen[species].purified
        image_pos.push(["Graphics/UI/SnagList/overlay_shadow", 224, 240, 0, 0, -1, -1])
        shadow_fract = pokemon.heart_gauge * 1.0 / GameData::ShadowPokemon::HEART_GAUGE_SIZE
        image_pos.push(["Graphics/UI/Summary/overlay_shadowbar", 242, 280, 0, 0, (shadow_fract * 248).floor, -1])
      end
    end
    pbDrawImagePositions(overlay, image_pos)
    base = Color.new(248, 248, 248)
    shadow = Color.new(104, 104, 104)
    pbSetSystemFont(overlay)
    species_name = GameData::Species.get(species).name
    # @type var text_pos: Array[text_position]
    text_pos = [
      [species_name, 50, 68, :left, base, shadow],
      [_ISPRINTF("First Seen"), 238, 86, :left, base, shadow],
      [$player.shadow_seen[species].location, 435, 118, :center, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [_INTL("Original Trainer"), 238, 150, :left, base, shadow],
      [_INTL("Location"), 238, 214, :left, base, shadow],
      [parse_pokemon_location(species), 435, 214, :center, Color.new(64, 64, 64), Color.new(176, 176, 176)],
    ]
    text_pos.push([_INTL("Heart Gauge"), 238, 246, 0, base, shadow])
    if $player.shadow_seen[species].snagged
      if $player.shadow_seen[species].purified
        heart_message = _INTL("Successfully overcame all difficult challenges!")
      else
        heart_message = [_INTL("The door to its heart is open! Undo the final lock!"),
                        _INTL("The door to its heart is almost fully open."),
                        _INTL("The door to its heart is nearly open."),
                        _INTL("The door to its heart is opening wider."),
                        _INTL("The door to its heart is opening up."),
                        _INTL("The door to its heart is tightly shut.")
        ][pokemon&.heartStage || 0]
      end
    else
      heart_message = _INTL("The Pokémon managed to escape capture.")
    end
    memo = sprintf("<c3=404040,B0B0B0>%s\n", heart_message)
    drawFormattedTextEx(overlay, 234, 308, 276, memo)
    owner_base = Color.new(64, 64, 64)
    owner_shadow = Color.new(176, 176, 176)
    if $player.shadow_seen[species].ot_gender == 0 # male OT
      owner_base = Color.new(24, 112, 216)
      owner_shadow = Color.new(136, 168, 208)
    elsif $player.shadow_seen[species].ot_gender == 1 # female OT
      owner_base = Color.new(248, 56, 32)
      owner_shadow = Color.new(224, 152, 144)
    end
    text_pos.push([$player.shadow_seen[species].ot, 435, 182, :center, owner_base, owner_shadow])
    if $player.shadow_seen[species].gender == 0
      text_pos.push([_INTL("♂"), 178, 68, 0, Color.new(24, 112, 216), Color.new(136, 168, 208)])
    elsif $player.shadow_seen[species].gender == 1
      text_pos.push([_INTL("♀"), 178, 68, 0, Color.new(248, 56, 32), Color.new(224, 152, 144)])
    end
    pbDrawTextPositions(overlay, text_pos)
    gender = $player.shadow_seen[species].gender
    form = $player.shadow_seen[species].form
    @sprites["entryicon"].setSpeciesBitmap(species, gender, form, false, !$player.shadow_seen[species].purified)
    @sprites["entryicon"].x = 112
    @sprites["entryicon"].y = 196
    GameData::Species.play_cry_from_species(species)
  end

  def snag_entry_on_index(index)
    old_sprites = pbFadeOutAndHide(@sprites)
    change_to_snag_entry(@snag_order[index][:species])
    pbFadeInAndShow(@sprites)
    current_index = index
    page = 1
    new_page = 0
    ret = 0
    pbActivateWindow(@sprites, nil) {
      window_loop(current_index, new_page, page, ret)
    }
    $PokemonGlobal.snag_index = current_index
    @sprites["snagList"].index = current_index
    @sprites["snagList"].refresh
    pbFadeInAndShow(@sprites, old_sprites)
  end

  def parse_pokemon_location(species)
    return "Fled" unless $player.shadow_seen[species].snagged
    $player.party.each do |pkmn|
      return "Party" if parse_evolution_line(species, pkmn)
    end
    (0...2).each { |i|
      return "Day Care" if parse_evolution_line(species, $PokemonGlobal.day_care[i].pokemon)
    }
    $PokemonStorage.boxes.each do |box|
      box.each do |pkmn|
        return box.name if parse_evolution_line(species, pkmn)
      end
    end
    (0...PurifyChamber::NUMSETS).each do |i|
      return "Set #{i + 1}" if parse_evolution_line(species, $PokemonGlobal.purifyChamber.getShadow(i))
      $PokemonGlobal.purifyChamber.setList(i).each do |pkmn|
        return "Set #{i + 1}" if parse_evolution_line(species, pkmn)
      end
    end
    return "Released"
  end

  def parse_evolution_line(original, pkmn)
    return false if pkmn.nil?
    return false unless $player.shadow_seen[original]
    return true if original == pkmn.species
    branches = GameData::Species.get(original).get_evolutions(true)
    branches.each do |evo|
      return true if parse_evolution_line(evo[0], pkmn)
    end
    return false
  end

  def window_loop(current_index, new_page, page, ret)
    loop do
      Graphics.update if page == 1
      Input.update
      update
      if Input.trigger?(Input::BACK) || ret == 1
        on_window_cancel(page)
        break
      elsif Input.trigger?(Input::UP) || ret == 8
        current_index, new_page = cursor_up(current_index, new_page, page)
      elsif Input.trigger?(Input::DOWN) || ret == 2
        current_index, new_page = cursor_down(current_index, new_page, page)
      elsif Input.trigger?(Input::USE)
        GameData::Species.play_cry_from_species(@snag_order[current_index][:species])
      end
      ret = 0
      if new_page > 0
        page = new_page
        new_page = 0
        @sprites["entryicon"].dispose
        change_to_snag_entry(@snag_order[current_index][:species])
      end
    end
  end

  def cursor_down(current_index, new_page, page)
    next_index = -1
    (current_index + 1...@snag_order.length).each { |i|
      if $player.shadow_seen[@snag_order[i][:species]]
        next_index = i
        break
      end
    }
    if next_index >= 0
      current_index = next_index
      new_page = page
    end
    pbPlayCursorSE if new_page > 1
    return current_index, new_page
  end

  def cursor_up(current_index, new_page, page)
    next_index = -1
    i = current_index - 1; loop do
      break unless i >= 0
      if $player.shadow_seen[@snag_order[i][:species]]
        next_index = i
        break
      end
      i -= 1
    end
    if next_index >= 0
      current_index = next_index
      new_page = page
    end
    pbPlayCursorSE if new_page > 1
    return current_index, new_page
  end

  def on_window_cancel(page)
    if page == 1
      pbPlayCancelSE
      pbFadeOutAndHide(@sprites)
      @sprites["entryicon"].dispose
      @sprites["snagEntry"].visible = false
      refresh
    end
  end
end
