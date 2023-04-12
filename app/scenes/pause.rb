class Pause < Scene
  include Sky
  include GamePlayLabels

  def initialize(args, current_scene_class, current_background=nil)
    super(args)
    @current_scene_class = current_scene_class
    @current_background = current_background
  end

  def tick
    args.audio[:music]&.paused = true
    args.audio[:boss_battle]&.paused = true

    if final_boss?
      args.outputs.solids << night_sky
    else
      args.outputs.primitives << @current_background
    end

    gameplay_labels

    args.outputs.labels << h_centered_label(text: "PAUSE", se: 40, y: 400, color: white)
    args.outputs.labels << h_centered_label(text: "'T' or 'B' button for main menu", se: 5, y: 275, color: white)

    if args.inputs.keyboard.key_down.space || args.inputs.controller_one.key_down.start
      args.state.scene = @current_scene_class.new(args)
      args.audio[:music]&.paused = false
      args.audio[:boss_battle]&.paused = false
    end

    if final_boss?
      args.outputs.primitives << [args.state.stars, args.state.explosions, args.state.player,
        args.state.fireballs, args.state.bullets, args.state.final_boss]
    else
      args.outputs.primitives << [args.state.clouds, args.state.saucers,
      args.state.explosions, args.state.player, args.state.fireballs, args.state.bullets]
    end

    if args.inputs.keyboard.key_down.t || args.inputs.controller_one.key_down.b
      $gtk.reset
      args.audio[:music] = nil
      args.audio[:boss_battle] = nil
      args.state.scene = TITLE_SCENE.new(args)
    end
  end

  # Needed in the GamePlayLabels
  def current_level
    final_boss? ? "Final Boss" : @current_scene_class::LEVEL_NUMBER
  end

  def final_boss?
    @current_scene_class == FINAL_BOSS_SCENE
  end
end
