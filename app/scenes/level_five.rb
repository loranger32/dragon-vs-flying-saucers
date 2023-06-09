class LevelFive < Scene
  include GamePlayScene

  LEVEL_NUMBER = 5
  BULLET_SPEED = 10
  BULLET_TICK_INTERVAL = 90
  SAUCERS_AT_START = 5
  MAX_SAUCER_COUNT = 8
  BG_PATH = "sprites/backgrounds/rock.png"

  def tick
    args.state.bullets_aimed ||= true

    return if super == :player_dead

    proceed_bullets

    if counter_end_level?
      return while args.state.saucers.size > 0 || args.state.bullets.size > 0

      args.outputs.sounds << "sounds/round_end.wav"
      args.state.saucers = nil
      args.state.timer_at_start_level = nil
      args.state.bullets = []
      args.state.fireballs = []

      args.state.scene = FINAL_BOSS_TRANSITION_SCENE.new(args)

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
