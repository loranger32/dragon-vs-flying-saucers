class LevelTransition < Scene
  include GamePlayLabels

  SPEED = 10
  END_LEVEL_TXT = "Level Finished"
  FADING_RATE = 3

  def initialize(args, bg_sprite, next_level_class)
    super(args)
    @bg = bg_sprite
    @phase = 1
    @next_level_class = next_level_class
  end

  def tick
    args.outputs.background_color = [0, 0, 0]
    inc_timer!
    debug_labels
    args.state.timer_at_start_transition ||= args.state.timer
    args.state.player.animate_sprite(args)

    args.outputs.primitives << @bg
    gameplay_labels
    Cloud.move_clouds(args)
    Fireball.move(args)
    args.outputs.primitives << [args.state.clouds, args.state.player]

    if first_3_seconds?
      args.outputs.labels << h_centered_label(text: END_LEVEL_TXT, y: 400, se: 40, color: WHITE)
      return
    end

    if args.state.player.x <= args.grid.w + 1 # + 1 to be sure it's out of screen
      args.state.player.x += SPEED
    else
      fade_all
    end

    if black_screen?
      reset_state_for_next_level
      args.state.scene = @next_level_class.new(args)
    end
  end

  def fade_all
    args.state.clouds.each { _1.fade(FADING_RATE + 2) }
    args.state.player.fade(FADING_RATE)
    @bg.fade(FADING_RATE)
  end

  def black_screen?
    args.state.player.a <= 0
  end

  def first_3_seconds?
    args.state.timer < args.state.timer_at_start_transition + 3
  end

  def reset_state_for_next_level
    args.state.timer_at_start_transition = nil
    args.state.clouds.each(&:restore_opacity)
    args.state.player.restore_opacity
    args.state.player.x = 40
    args.state.player.y = 320
    args.state.fireball = []
    args.state.saucers = nil
    args.state.bullets = nil
  end

  def current_level
    @next_level_class::LEVEL_NUMBER - 1
  end
end
