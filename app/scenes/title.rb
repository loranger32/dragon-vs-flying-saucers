class Title < Scene
  include Sky

  def tick
    gameplay_sky

    labels = []
    labels << {
      x: 40,
      y: args.grid.h - 40,
      text: "Dragon vs Flying Saucers",
      size_enum: 8,
    }

    labels << {
      x: 40,
      y: args.grid.h - 100,
      text: "Destroy the Flying Saucers !",
    }

    labels << {
      x: 40,
      y: args.grid.h - 130,
      text: "By Laurent Guinotte"
    }

    labels << {
      x: 40,
      y: args.grid.h - 150,
      text: "Based on \"Building Games with DragonRuby\" - Brett Chalupa"
    }

    labels << {
      x: 40,
      y: 120,
      text: "Keyboard : Arrows or WASD to move | 'Z', 'Q' or 'J' to fire | SPACE to pause | 'C' for credits"
    }

    labels << {
      x: 40,
      y: 80,
      text: "Gamepad works too : A to fire | start to pause | B for main menu | Y for credits"
    }

    labels << {
      x: 40,
      y: 40,
      text: "Fire to start",
      size_enum: 2
    }

    args.outputs.labels << labels

    args.state.player ||= Player.new(x: (args.grid.w / 2) - 100, y: (args.grid.h / 2) - 85, w: 200, h: 170)
    args.state.saucers ||= [Saucer.new(x: 150, y: 300, w: 100, h: 100), Saucer.new(x: 1050, y: 300, w: 100, h: 100)]
    args.outputs.sprites << args.state.player
    args.outputs.sprites << args.state.saucers
    args.state.player.animate_sprite(args)
    Saucer.animate(args.state.saucers)

    if fire_input?(args)
      $gtk.reset
      args.outputs.sounds << "sounds/game-over.wav"
      args.state.scene = LEVEL_ONE_SCENE.new(args)
      return
    end

    if args.inputs.keyboard.key_down.c || args.inputs.controller_one.key_down.y
      args.state.scene = CREDIT_SCENE.new(args)
      return
    end

    debug_labels
  end
end
