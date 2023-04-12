class LevelTwo < Scene
  include GamePlayScene

  LEVEL_NUMBER = 2
  SAUCERS_AT_START = 10
  MAX_SAUCER_COUNT = 20
  BG_PATH = "sprites/backgrounds/background0.png"

  def tick
    super

    if counter_end_level?
      return while args.state.saucers.size > 0
      args.state.saucers = nil
      args.state.timer_at_start_level = nil
      args.outputs.sounds << "sounds/round_end.wav"
      args.state.scene = LEVEL_THREE_SCENE.new(args)
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
end
