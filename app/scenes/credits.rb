class Credits < Scene
  include Sky

  def tick
    if args.audio[:credits].nil? && !args.state.credits_music_launched
      args.audio[:credits] = { input: "sounds/credits.ogg", looping: false, gain: $gtk.production? ? 1.0 : 0.5 }
      args.state.credits_music_launched = true
    end
    args.outputs.solids << night_sky
    args.state.stars ||= Star.populate_sky(args, 100)
    Star.animate(args.state.stars)
    args.outputs.sprites << args.state.stars

    # Populate args.state.credits_labels and args.state.credits_sprites
    gen_credits_labels_and_sprites(args) unless args.state.sprites_and_labels_initialized

    args.outputs.labels << args.state.credits_labels
    args.outputs.sprites << args.state.credits_sprites

    # Manual scrolling - Useful for development
    # if args.inputs.keyboard.down
    #   move_credits(10)
    # elsif args.inputs.keyboard.up
    #   move_credits(-10)
    # end

    move_credits(0.8)

    if args.inputs.keyboard.key_down.t || args.inputs.controller_one.key_down.y ||args.state.credits_labels.last.y > 800
      reset_state!
      args.state.scene = TITLE_SCENE.new(args)
    end

    debug_labels
  end

  def gen_credits_labels_and_sprites(args)
    labels = []
    sprites = []
    spacer = VSpacer.new(args.grid.h)


    ############################## BEGIN ######################################

    labels << h_centered_label(text: "Dragon", se: 20, y: spacer - 200, color: white)
    labels << h_centered_label(text: "vs", se: 20, y: spacer - 100, color: white)
    labels << h_centered_label(text: "Flying Saucers", se: 20, y: spacer - 100, color: white)

    labels << h_centered_label(text: "CREDITS", se: 25, y: spacer - 150, color: white)

    labels << h_centered_label(text: "AUTHOR", se: 10, y: spacer - 120, color: white)
    labels << h_centered_label(text: "loranger32", se: 5, y: spacer - 75, color: white)
    labels << h_centered_label(text: "https://loranger32.itch.io", se: 1, y: spacer - 40, color: white)
    labels << h_centered_label(text: "https://github.com/loranger32", se: 1, y: spacer - 40, color: white)
    labels << h_centered_label(text: "Based on the 'Traget Practice' DragonRuby tutorial from Brett Chalupa", se: 1, y: spacer - 50, color: white)
    labels << h_centered_label(text: "https://book.dragonriders.community", se: 1, y: spacer - 40, color: white)
    labels << h_centered_label(text: "(thank you very much for this !)", se: 1, y: spacer - 40, color: white)


    ############################## SPRITES ####################################

    labels << h_centered_label(text: "SPRITES", se: 10, y: spacer - 120, color: white)

    player = Player.new(x: 300, y: spacer - 140, w: 100, h: 100)
    player.path = "sprites/dragon/dragon-0.png"
    sprites << player
    explosion = Explosion.new(x: 600, y: spacer.y, birth: args.state.tick_count)
    explosion.path = "sprites/fireball_explosion/explosion-3.png"
    sprites << explosion
    sprites << {x: 900, y: spacer.y, w: 50, h: 50, path: "sprites/star.png"}

    labels << h_centered_label(text: "dragon, flying saucers explosions and stars: DragonRuby Engine package", se: 5, y: spacer - 40, color: white)

    sprites << {x: 620, y: spacer - 140, w: 50, h: 50, path: "sprites/fireball.png"}
    labels << h_centered_label(text: "fireball: Brett Chalupa", se: 5, y: spacer - 20, color: white)
    labels << h_centered_label(text: "https://book.dragonriders.community/03-spit-fire.html", se: 1, y: spacer - 40, color: white)

    sprites << { x: 600, y: spacer - 180, w: 100, h: 100, path: "sprites/cloud.png"}
    labels << h_centered_label(text: "cloud: Ian Peter", se: 5, y: spacer - 20, color: white)
    labels << h_centered_label(text: "https://opengameart.org/users/ian-peter", se: 1, y: spacer - 40, color: white)

    sprites << {x: 600, y: spacer - 180, w: 100, h: 100, path: "sprites/flying_saucer/flying-saucer-0.png"}
    labels << h_centered_label(text: "flying saucers: Gamedevtuts+", se: 5, y: spacer - 20, color: white)
    labels << h_centered_label(text: "http://gamedev.tutsplus.com/articles/news/enjoy-these-totally-free-space-based-shoot-em-up-sprites", se: 1, y: spacer - 40, color: white)

    sprites << {x: 600, y: spacer - 180, w: 100, h: 100, path: "sprites/alienshiptex.png"}
    labels << h_centered_label(text: "Final Boss: MillionthVector", se: 5, y: spacer - 20, color: white)
    labels << h_centered_label(text: "http://millionthvector.blogspot.de", se: 1, y: spacer - 40, color: white)
    labels << h_centered_label(text: "Creative Commons BY License: https://creativecommons.org/licenses/by/4.0/", se: 1, y: spacer - 40, color: white)

    sprites << {x: 600, y: spacer - 180, w: 100, h: 100, path: "sprites/dragon_explosion/dragon-explosion-4.png"}
    labels << h_centered_label(text: "player explosion: jrob774", se: 5, y: spacer - 20, color: white)
    labels << h_centered_label(text: "https://opengameart.org/users/jrob774", se: 1, y: spacer - 40, color: white)

    sprites << {x: 600, y: spacer - 180, w: 100, h: 100, path: "sprites/big_explosion/big_explosion-1.png"}
    labels << h_centered_label(text: "final boss explosion: Cuzco", se: 5, y: spacer - 20, color: white)
    labels << h_centered_label(text: "https://opengameart.org/content/explosion", se: 1, y: spacer - 40, color: white)

    sprites << {x: 120, y: spacer - 240, w: 240, h: 144, path: "sprites/backgrounds/background0.png"}
    sprites << {x: 480, y: spacer.y, w: 240, h: 144, path: "sprites/backgrounds/snow.png"}
    sprites << {x: 840, y: spacer.y, w: 240, h: 144, path: "sprites/backgrounds/rock.png"}
    labels << h_centered_label(text: "backgrounds: greggman", se: 5, y: spacer - 20, color: WHITE)
    labels << h_centered_label(text: "https://opengameart.org/content/backgrounds-for-2d-platformers", se: 1, y: spacer - 40, color: WHITE)


    ############################## SOUND AND MUSIC ############################

    labels << h_centered_label(text: "SOUNDS AND MUSICS", se: 10, y: spacer - 120, color: white)
    labels << h_centered_label(text: "in-game music, fireball shoot and flying saucer explosion: Brett Chalupa", se: 5, y: spacer - 100, color: white)
    labels << h_centered_label(text: "https://book.dragonriders.community/08-sound.html", se: 1, y: spacer - 40, color: white)

    labels << h_centered_label(text: "game-over sound: Sauer", se: 5, y: spacer - 75, color: white)
    labels << h_centered_label(text: "https://opengameart.org/content/oldschool-win-and-die-jump-and-run-sounds", se: 1, y: spacer - 40, color: white)

    labels << h_centered_label(text: "final boss music: Orbital Colossus by Matthew Pablo", se: 5, y: spacer - 75, color: white)
    labels << h_centered_label(text: "https://matthewpablo.com", se: 1, y: spacer - 40, color: white)

    labels << h_centered_label(text: "credits music: the-field-of-dreams by pauliuw", se: 5, y: spacer - 75, color: white)
    labels << h_centered_label(text: "https://opengameart.org/content/the-field-of-dreams", se: 1, y: spacer - 40, color: white)

    labels << h_centered_label(text: "end game music: Victory!", se: 5, y: spacer - 75, color: white)
    labels << h_centered_label(text: "Composed, performed, mixed and mastered by Viktor Kraus", se: 1, y: spacer - 40, color: white)
    labels << h_centered_label(text: "https://opengameart.org/content/victory-1", se: 1, y: spacer - 40, color: white)
    labels << h_centered_label(text: "THANK YOU FOR PLAYING THIS GAME", se: 20, y: spacer - 200, color: white)

    args.state.credits_labels = labels
    args.state.credits_sprites = sprites
    args.state.sprites_and_labels_initialized = true
  end


  def move_credits(delta_y)
    args.state.credits_labels.each { |label| label.y += delta_y }
    args.state.credits_sprites.each { |sprite| sprite.y += delta_y }
  end

  def reset_state!
    args.audio[:credits] = nil
    args.state.credits_music_launched = nil
    args.state.credits_labels = nil
    args.state.credits_sprites = nil
    args.state.player = nil
    args.state.stars = nil
    args.state.sprites_and_labels_initialized = nil
  end
end
