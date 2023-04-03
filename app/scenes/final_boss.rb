class LevelSix < Scene
  include Sky

  def tick
    args.outputs.solids << night_sky
    args.state.stars ||= Star.populate_sky(args, 100)
    Star.animate(args.state.stars)
    args.outputs.sprites << args.state.stars

    gain = $gtk.production? ? 0.6 : 0.2
    args.audio[:music].paused = true
    args.audio[:boss_battle] ||= { input: "sounds/flight.ogg", looping: true, gain: gain }

    # Pause
    args.state.game_paused ||= false

    # Fireballs
    args.state.fireballs   ||= []

    # Explosions
    args.state.explosions  ||= []

    # Bullets
    args.state.bullets     ||= []

    # Score
    args.state.score       ||= 0

    if args.inputs.keyboard.key_down.space
      args.state.scene = PAUSE_SCENE.new(args, self.class)
    end
  end
end
