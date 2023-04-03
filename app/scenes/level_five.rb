class LevelFive < Scene
  include GamePlayScene

  LEVEL_NUMBER = 5
  BULLET_SPEED = 10
  BULLET_TICK_INTERVAL = 90
  SAUCERS_AT_START = 5
  MAX_SAUCER_COUNT = 8

  def tick
    args.state.bullets_aimed ||= true
    super

    proceed_bullets

    if counter_end_level?
      return while args.state.saucers.size > 0 || args.state.bullets.size > 0
      args.state.victory ||= true
      args.state.timer_at_victory ||= args.state.timer
      args.audio[:music] = nil
      args.audio[:end_game] ||= {input: "sounds/end_game.ogg", loop: false}
      if args.state.timer - args.state.timer_at_victory < 20
        display_victory
        inc_timer!
      else
        args.state.scene = GAME_OVER_SCENE.new(args)
      end
    else
      replace_killed_saucers
    end
  end

  def replace_killed_saucers
    args.state.saucers_killed&.times do
      2.times { args.state.saucers << Saucer.spawn_saucer(args) unless args.state.saucers.size >= MAX_SAUCER_COUNT }
    end
    args.state.saucers_killed = 0
  end

  def proceed_bullets
    if args.state.tick_count % BULLET_TICK_INTERVAL == 0
      Saucer.shoot(args, BULLET_SPEED)
    end
    Bullet.move(args.state.bullets)
  end

  def display_victory
    args.outputs.primitives << h_centered_label(text: "VICTORY !!!", se: 30, y: 400, color: WHITE).label!
  end
end
