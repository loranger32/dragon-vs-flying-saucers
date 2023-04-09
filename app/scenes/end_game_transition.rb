class EndGameTransition < Scene
  include Sky

  AUTOPILOT_SPEED = 6

  def initialize(args)
    super
    @scene = 1
  end

  def tick
    args.state.timer_at_start_transition ||= args.state.timer
    args.state.player.animate_sprite(args)
    debug_position

    if @scene == 1
      Cloud.move_clouds(args)
      gameplay_sky
      args.outputs.sprites << [args.state.clouds, args.state.player]
      if first_seconds?(3)
        transition_label
        inc_timer!
        return
      end

      move_player_to_center
      inc_timer!
      @scene = 2 if args.state.player.at_center?(args)
    end

    if @scene == 2
      gameplay_sky
      Cloud.move_clouds(args)
      args.outputs.sprites << [args.state.clouds, args.state.player]
      if first_seconds?(5)
        inc_timer!
        return
      end

      move_player_up
      inc_timer!
      @scene = 3 if player_out_of_screen?
    end

    if @scene == 3
      set_player_at_bottom
      transition_sky
      generate_new_clouds
      Cloud.move_clouds(args)
      move_player_up
      args.outputs.sprites << [args.state.clouds, args.state.player]

      inc_timer!
      if player_out_of_screen?
        @scene = 4
        args.state.player_already_set_at_bottom = false
      end
    end

    if @scene == 4
      set_player_at_bottom
      args.outputs.solids << night_sky
      args.state.stars ||= Star.populate_sky(args, 50)
      args.outputs.sprites << [args.state.stars, args.state.player]
      Star.animate(args.state.stars)

      inc_timer!
      if args.state.player.y < (args.grid.h / 2) - (args.state.player.h / 2)
        move_player_up
      else
        move_player_right
      end

      if player_out_of_screen?
        args.state.scene = FINAL_BOSS_SCENE.new(args)
      end
    end
  end

  def move_player_up
    args.state.player.y += 3
  end

  def move_player_right
    args.state.player.x += 10
  end

  def player_out_of_screen?
    args.state.player.x >= args.grid.w || args.state.player.y >= args.grid.h
  end

  def move_player_to_center
    unless args.state.player.vect
      theta = Math.atan2(args.state.player.y - 360, args.state.player.x - 600)
      args.state.player.vect = theta.to_degrees.to_vector(AUTOPILOT_SPEED)
    end
    args.state.player.auto_pilot(args)
  end

  def transition_label
    if args.state.tick_count % 60 > 30
      args.outputs.primitives << h_centered_label(text: "Final Boss Incoming", y: 400, se: 40, color: WHITE).label!
    end
  end

  def first_seconds?(sec)
    args.state.timer < args.state.timer_at_start_transition + sec
  end

  def generate_new_clouds
    return if args.state.new_clouds_generated

    args.state.clouds = Cloud.init_clouds(args, 5)
    args.state.new_clouds_generated = true
  end

  def set_player_at_bottom
    return if args.state.player_already_set_at_bottom

    args.state.player.x = args.grid.w / 2 - args.state.player.w
    args.state.player.y = 0
    args.state.player_already_set_at_bottom = true
  end

  def debug_position
    args.outputs.labels << {x: 40, y: 680, text: "X pos: #{args.state.player.x}"}.merge(WHITE)
    args.outputs.labels << {x: 40, y: 640, text: "Y pos: #{args.state.player.y}"}.merge(WHITE)
  end
end
