class LevelFour < Scene
  include GamePlayScene

  LEVEL_NUMBER = 4
  BULLET_SPEED = 8
  BULLET_TICK_INTERVAL = 180
  SAUCERS_AT_START = 5
  MAX_SAUCER_COUNT = 6

  def tick
    args.state.bullets_aimed ||= true
    return if super == :player_dead
    
    proceed_bullets

    if counter_end_level?
      return while args.state.saucers.size > 0 || args.state.bullets.size > 0
      args.state.saucers = nil
      args.state.timer_at_start_level = nil
      args.outputs.sounds << "sounds/round_end.wav"
      args.state.scene = LEVEL_FIVE_SCENE.new(args)
    else
      replace_killed_saucers
    end
  end

  def replace_killed_saucers
    args.state.saucers_killed&.times do
      2.times { args.state.saucers << Saucer.spawn_saucer(args) unless args.state.saucers.size >= MAX_SAUCER_COUNT }
    end
  end

  def proceed_bullets
    if args.state.tick_count % BULLET_TICK_INTERVAL == 0
      Saucer.shoot(args, BULLET_SPEED)
    end
    Bullet.move(args.state.bullets)
  end
end
