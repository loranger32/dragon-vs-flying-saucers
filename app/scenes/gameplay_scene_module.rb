module GamePlayScene
  include Sky
  include GamePlayLabels

  def tick
    # Main music
    gain = $gtk.production? ? 0.6 : 2.0
    args.audio[:music] ||= { input: "sounds/flight.ogg", looping: true, gain: gain }

    # Sky
    gameplay_sky

    # Timer
    args.state.timer ||= 0
    args.state.timer_at_start_level ||= args.state.timer

    # Pause
    args.state.game_paused ||= false

    # Saucers
    args.state.saucers     ||= Saucer.init_saucers(args, self.class::SAUCERS_AT_START)

    # clouds
    args.state.clouds      ||= Cloud.init_clouds(args, 20)

    # Player
    args.state.player      ||= Player.new(x: 120, y: 280)

    # Fireballs
    args.state.fireballs   ||= []

    # Explosions
    args.state.explosions  ||= []

    # Bullets
    args.state.bullets     ||= []

    # Score
    args.state.score       ||= 0

    if args.inputs.keyboard.key_down.space || args.inputs.controller_one.key_down.start
      args.state.scene = PAUSE_SCENE.new(args, self.class)
    end

    Saucer.animate(args.state.saucers)
    Saucer.move(args.state.saucers)
    Cloud.move_clouds(args)
    Fireball.move(args)

    args.state.saucers_killed = args.state.saucers.count(&:dead)
    args.state.saucers.reject!(&:dead)
    args.state.fireballs.reject!(&:dead)

    Explosion.animate(args)

    inc_timer!

    proceed_player_and_fireballs

    ## Labels
    gameplay_labels
    level_label
    args.outputs.primitives << [args.state.clouds, args.state.saucers, args.state.explosions,
      args.state.player, args.state.fireballs, args.state.bullets]

    args.outputs.debug << {x: 40, y: 80, text: "Timer: #{args.state.timer}"}.merge(white)
    args.outputs.debug << {x: 40, y: 40, text: "FR: #{args.gtk.current_framerate}"}.merge(white)
  end

  def proceed_player_and_fireballs
    if args.state.player.alive
      args.state.player.animate_sprite(args)
      args.state.player.move(args)
      Fireball.shoot(args) if fire_input?(args)
    else
      args.state.player.animate_explosion(args)
      if args.state.player_explosion_finished
        args.audio[:music] = nil
        args.state.scene = GAME_OVER_SCENE.new(args)
      end
    end
  end

  def counter_end_level?
    args.state.timer >= args.state.timer_at_start_level + SCENE_DURATION
  end

  def current_level
    self.class::LEVEL_NUMBER
  end

  def level_label
    if first_3_seconds?
      args.outputs.labels << h_centered_label(text: "LEVEL #{current_level}", y: 400, se: 40, color: WHITE)
    end
  end

  def first_3_seconds?
    args.state.timer < args.state.timer_at_start_level + 3
  end
end
