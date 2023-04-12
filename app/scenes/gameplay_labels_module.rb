module GamePlayLabels
  def gameplay_labels
    #########
    # SCORE #
    #########

    # Score Text
    score_txt = "Score: #{args.state.score}"

    score = {x: 40, y: args.grid.h - 40, text: score_txt, size_enum: 4}.merge(WHITE).label!

    score_w, score_h = args.gtk.calcstringbox(score_txt, 4)
    bg_score_x = 30
    bg_score_y = args.grid.h - 45 - score_h
    score_w += 20
    score_h += 15

    # Border around score solid
    border_around_score = {x: bg_score_x - 3, y: bg_score_y - 3, w: score_w + 6, h: score_h + 6}.merge(YELLOW).solid!

    # Solid around score
    solid_around_score = {x: bg_score_x, y: bg_score_y, w: score_w, h: score_h, r: 50, g: 50, b: 250}.solid!

    args.outputs.primitives << [border_around_score, solid_around_score, score]

    ###################
    # Lives Remaining #
    ###################

    # Lives Remaining Text
    lr_text = "Lives: #{args.state.remaining_attempts}"
    lives_remaining = h_centered_label(text: lr_text, y: args.grid.h - 40, se: 4, color: WHITE).label!

    # Border around Lives Remaining Solid
    lr_w, lr_h = args.gtk.calcstringbox(lr_text, 4)
    lr_x = (args.grid.w / 2) - (lr_w / 2) - 15
    lr_y = args.grid.h - 45 - lr_h

    lr_w += 30
    lr_h += 15

    border_around_lives_remaining = {x: lr_x - 3, y: lr_y - 3, w: lr_w + 6, h: lr_h + 6}.merge(YELLOW).solid!

    # Solid around Lives Remaining
    solid_around_lives_remaining = {x: lr_x, y: lr_y, w: lr_w, h: lr_h, r: 50, g: 50, b: 250}.solid!

    args.outputs.primitives << [border_around_lives_remaining, solid_around_lives_remaining, lives_remaining]

    #########
    # LEVEL #
    #########

    # Level Text
    level_txt = if args.state.scene.class == FINAL_BOSS_SCENE
       "Final Boss"
    else
      "Level #{current_level}"
    end

    level = {x: args.grid.w - 40, y: args.grid.h - 40, text: level_txt, size_enum: 4, alignment_enum: 2}.merge(WHITE).label!

    level_w, level_h = args.gtk.calcstringbox(level_txt, 4)
    bg_level_x = args.grid.w - level_w - 50
    bg_level_y = args.grid.h - level_h - 45
    level_w += 20
    level_h += 15

    # Border around Level solid
    border_around_level = {x: bg_level_x - 3, y: bg_level_y - 3, w: level_w + 6, h: level_h + 6}.merge(YELLOW).solid!

    # Solid around Level
    solid_around_level = {x: bg_level_x, y: bg_level_y, w: level_w, h: level_h, r: 50, g: 50, b: 250}.solid!

    args.outputs.primitives << [border_around_level, solid_around_level, level]
  end
end
