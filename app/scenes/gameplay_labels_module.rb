module GamePlayLabels
  def gameplay_labels
    # Score
    score_txt = "Score: #{args.state.score}"
    args.outputs.primitives << {
      x: 40,
      y: args.grid.h - 40,
      text: score_txt,
      size_enum: 4
  }.merge(WHITE).label!

    score_w, score_h = args.gtk.calcstringbox(score_txt, 4)
    bg_score_x = 30
    bg_score_y = args.grid.h - 45 - score_h
    score_w += 20
    score_h += 15

    # Border around score solid
    args.outputs.solids << {
      x: bg_score_x - 3,
      y: bg_score_y - 3,
      w: score_w + 6,
      h: score_h + 6
    }.merge(YELLOW)

    # Solid around score
    args.outputs.solids << {
      x: bg_score_x,
      y: bg_score_y,
      w: score_w,
      h: score_h,
      r: 50,
      g: 50,
      b: 250
    }

    # Level
    level_txt = if args.state.scene.class == FINAL_BOSS_SCENE
       "Final Boss"
    else
      "Level #{current_level}"
    end
    args.outputs.primitives << {
      x: args.grid.w - 40,
      y: args.grid.h - 40,
      text: level_txt,
      size_enum: 4,
      alignment_enum: 2
    }.merge(WHITE).label!

    level_w, level_h = args.gtk.calcstringbox(level_txt, 4)
    bg_level_x = args.grid.w - level_w - 50
    bg_level_y = args.grid.h - level_h - 45
    level_w += 20
    level_h += 15

    # Border around Level solid
    args.outputs.solids << {
      x: bg_level_x - 3,
      y: bg_level_y - 3,
      w: level_w + 6,
      h: level_h + 6,
    }.merge(YELLOW)

    # Solid around Level
    args.outputs.solids << {
      x: bg_level_x,
      y: bg_level_y,
      w: level_w,
      h: level_h,
      r: 50,
      g: 50,
      b: 250,
    }
  end
end
