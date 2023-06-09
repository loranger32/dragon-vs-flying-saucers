class LevelThree < Scene
  include GamePlayScene

  LEVEL_NUMBER = 3
  BULLET_SPEED = 8
  BULLET_TICK_INTERVAL = 180
  SAUCERS_AT_START = 5
  MAX_SAUCER_COUNT = 6
  BG_PATH = "sprites/backgrounds/snow.png"

  def tick
    return if super == :player_dead

    proceed_bullets

    if counter_end_level?
      return while args.state.saucers.size > 0 || args.state.bullets.size > 0
      args.state.timer_at_start_level = nil
      args.outputs.sounds << "sounds/round_end.wav"
      args.state.scene = LEVEL_TRANSITION_SCENE.new(args, bg_sprite, LEVEL_FOUR_SCENE)
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
end
