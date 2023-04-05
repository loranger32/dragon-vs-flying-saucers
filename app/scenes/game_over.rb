class GameOver < Scene
  include Sky

  def tick
    # Faded sky background
    args.outputs.solids << night_sky

    args.state.timer_at_start_game_over_scene ||= args.state.timer

    game_over_labels = []
    game_over_labels << {
      x: 40,
      y: args.grid.h - 40,
      text: "Score: #{args.state.score}",
      size_enum: 4
    }.merge(white)

    game_over_text = args.state.victory ? "Congratulations" : "Game Over !"

    game_over_title = h_centered_label(text: game_over_text, se: 20, y: args.grid.h - 100, color: white)

    if args.state.tick_count % 60 > 30
      game_over_labels << game_over_title
    end

    game_over_labels << {
      x: 40,
      y: args.grid.h - 80,
      text: "Press fire to play again"
    }.merge(white)

    game_over_labels << {
      x: 40,
      y: args.grid.h - 120,
      text: "'T' or 'B' button for main menu"
    }.merge(white)

    game_over_labels << {
      x: 40,
      y: args.grid.h - 160,
      text: "'R' or 'select' button to reset highscores"
    }.merge(white)

    game_over_labels << {
      x: 40,
      y: args.grid.h - 200,
      text: "'C' or 'Y' button to see credits"
    }.merge(white)

    if args.state.high_score_reset
      game_over_labels << h_centered_label(text: "High Score Reset", se: 10, y: 400, color: white)
    else
      args.state.high_score_records ||= HighScores.load(args, HIGH_SCORE_FILE)
      args.state.high_score_records.save!(args, HIGH_SCORE_FILE) if new_high_score?(args)

      args.state.current_score_label ||= args.state.high_score_records.label_current_score(args)
      args.state.high_scores_label ||= args.state.high_score_records.label_all_high_score(args)

      game_over_labels << args.state.current_score_label
      game_over_labels << args.state.high_scores_label
    end

    args.outputs.labels << game_over_labels

    if args.state.timer > args.state.timer_at_start_game_over_scene && fire_input?(args)
      $gtk.reset
      args.state.scene = LEVEL_ONE_SCENE.new(args)
    end

    if args.inputs.keyboard.key_down.t || args.inputs.controller_one.b
      $gtk.reset
      args.state.scene = TITLE_SCENE.new(args)
    end

    if args.inputs.keyboard.key_down.c || args.inputs.controller_one.key_down.y
      $gtk.reset
      args.state.scene = CREDIT_SCENE.new(args)
    end

    if args.inputs.keyboard.key_down.r || args.inputs.controller_one.key_down.select
      HighScores.reset!
      args.state.high_score_reset = true
    end

    inc_timer!

    # Show Credits just after end game music if player has not dismissed the game over scene yet
    if args.state.victory && args.audio[:end_game].nil?
      args.state.scene = CREDIT_SCENE.new(args)
    end

    debug_labels
  end

  def new_high_score?(args)
    !args.state.high_score_saved && args.state.high_score_records.new_high_score?(args.state.score)
  end
end
