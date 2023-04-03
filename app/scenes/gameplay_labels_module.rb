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
    timer_txt = "Level #{current_level}"
    args.outputs.primitives << {
      x: args.grid.w - 40,
      y: args.grid.h - 40,
      text: timer_txt,
      size_enum: 4,
      alignment_enum: 2
    }.merge(WHITE).label!

    timer_w, timer_h = args.gtk.calcstringbox(timer_txt, 4)
    bg_timer_x = args.grid.w - timer_w - 50
    bg_timer_y = args.grid.h - timer_h - 45
    timer_w += 20
    timer_h += 15

    # Border around Level solid
    args.outputs.solids << {
      x: bg_timer_x - 3,
      y: bg_timer_y - 3,
      w: timer_w + 6,
      h: timer_h + 6,
    }.merge(YELLOW)

    # Solid around Level
    args.outputs.solids << {
      x: bg_timer_x,
      y: bg_timer_y,
      w: timer_w,
      h: timer_h,
      r: 50,
      g: 50,
      b: 250,
    }
  end
end
