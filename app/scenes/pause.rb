class Pause < Scene
  include Sky
  include GamePlayLabels

  def initialize(args, current_scene_class)
    super(args)
    @current_scene_class = current_scene_class
  end

  def tick
    args.audio[:music].paused = true

    gameplay_sky
    gameplay_labels

    args.outputs.labels << h_centered_label(text: "PAUSE", se: 40, y: 400, color: white)
    args.outputs.labels << h_centered_label(text: "'T' or 'B' button for main menu", se: 5, y: 275, color: white)

    if args.inputs.keyboard.key_down.space || args.inputs.controller_one.key_down.start
      args.state.scene = @current_scene_class.new(args)
      args.audio[:music].paused = false
    end

    args.outputs.primitives << [args.state.clouds, args.state.saucers, args.state.explosions, args.state.player, args.state.fireballs, args.state.bullets]

    if args.inputs.keyboard.key_down.t || args.inputs.controller_one.key_down.b
      $gtk.reset
      args.audio[:music] = nil
      args.state.scene = TITLE_SCENE.new(args)

    end
  end

  # Needed in the GamePlayLabels
  def current_level
    @current_scene_class::LEVEL_NUMBER
  end
end
