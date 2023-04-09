class Logo < Scene
  LOGO_PATH = "sprites/dr-logo.png"
  LOGO_W = 800
  LOGO_H = 480
  TRANSITION_DURATION = 60

  def tick
    args.outputs.background_color = [0, 0, 0]
    if args.state.tick_count == 0
      args.state.label = h_centered_label(text: "Made With DragonRuby Toolkit", se: 20, y: 640, color: WHITE).merge(a: 255)
      args.state.logo = {x: 240, y: 40, w: LOGO_W, h: LOGO_H, path: LOGO_PATH, a: 255}
      args.outputs.static_labels << args.state.label
      args.outputs.static_sprites << args.state.logo
    end
    
    if args.state.tick_count >= 240
      [args.state.label, args.state.logo].each { _1.a -= 4.25 }
    end

    if args.state.tick_count >= 301
      $gtk.reset
      args.state.scene = TITLE_SCENE.new(args)
    end

    debug_labels
  end
end
