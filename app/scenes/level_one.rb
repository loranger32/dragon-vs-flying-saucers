class LevelOne < Scene
  include GamePlayScene

  LEVEL_NUMBER = 1
  SAUCERS_AT_START = 4
  BG_PATH = "sprites/backgrounds/background0.png"

  def tick
    super

    if counter_end_level?
      return while args.state.saucers.size > 0
      args.state.timer_at_start_level = nil
      args.outputs.sounds << "sounds/round_end.wav"

      args.state.scene = LEVEL_TRANSITION_SCENE.new(args, bg_sprite, LEVEL_TWO_SCENE)
    else
      replace_killed_saucers
    end
  end

  def replace_killed_saucers
    args.state.saucers_killed&.times { args.state.saucers << Saucer.spawn_saucer(args) }
    args.state.saucers_killed = 0
  end
end
