class FinalLevel < Scene
  include Sky
  include GamePlayLabels

  PLAYER_X_AT_START = 200
  PLAYER_Y_AT_START = 350

  def tick
    args.state.timer_at_start_level ||= args.state.timer

    args.audio[:music] = nil
    args.audio[:boss_battle] ||= { input: "sounds/orbitalcolossus.ogg", looping: true, gain: gain }

    args.outputs.solids << night_sky
    args.state.stars ||= Star.populate_sky(args, 50)

    args.state.final_boss ||= FinalBoss.new(x: 900, y: 300)

    if first_3_seconds?
      args.state.player.x = PLAYER_X_AT_START
      args.state.player.y = PLAYER_Y_AT_START
    end

    if args.inputs.keyboard.key_down.space || args.inputs.controller_one.key_down.start
      args.state.scene = PAUSE_SCENE.new(args, self.class)
    end

    level_label

    unless boss_dead? || first_3_seconds?
      args.state.final_boss.move(args)
      args.state.final_boss.shoot(args)
    end

    Star.animate(args.state.stars)

    Bullet.move(args.state.bullets)

    Fireball.move_final_boss(args)
    Explosion.animate(args)
    args.state.explosions.reject!(&:dead)

    if args.state.player.alive
      args.state.player.animate_sprite(args)
      args.state.player.move(args) unless first_3_seconds?

      unless (boss_dead? || first_3_seconds?)
        Fireball.shoot(args) if fire_input?(args)
      end
    else
      args.state.player.animate_explosion(args)
      if args.state.player_explosion_finished
        if args.state.remaining_attempts >= 0
          reset_state_for_new_attempt
          return
        else
          args.audio[:boss_battle] = nil
          args.state.scene = GAME_OVER_SCENE.new(args)
        end
      end
    end

    if boss_dead?
      args.state.final_boss.death_tick ||= args.state.tick_count
      args.state.final_boss.animate_explosion(args)
      if args.state.final_boss_explosion_finished && args.state.bullets.empty?
        args.state.victory ||= true
        add_bonus_score
        args.state.timer_at_victory ||= args.state.timer
        args.audio[:boss_battle] = nil
        args.audio[:end_game] ||= {input: "sounds/end_game.ogg", loop: false}

        args.outputs.primitives << [args.state.stars, args.state.fireballs]
        gameplay_labels
        args.outputs.primitives << args.state.player
        inc_timer!
        if args.state.timer - args.state.timer_at_victory < 20
          display_victory
        else
          args.state.scene = GAME_OVER_SCENE.new(args)
        end
        return
      end
    end

    args.outputs.sprites << [args.state.stars, args.state.player, args.state.fireballs, args.state.final_boss, args.state.explosions, args.state.bullets]
    gameplay_labels
    debug_labels
    args.outputs.debug << {x: 40, y: 120, text: "Boss HP: #{args.state.final_boss.hp}"}.merge(white)
    inc_timer!
  end

  def display_victory
    args.outputs.primitives << h_centered_label(text: "VICTORY !!!", se: 30, y: 400, color: WHITE).label!
  end

  def current_level
    "Final Boss"
  end

  def first_3_seconds?
    args.state.timer < args.state.timer_at_start_level + 3
  end

  def level_label
    if first_3_seconds?
      args.outputs.labels << h_centered_label(text: "Final Boss", y: 400, se: 40, color: WHITE)
    end
  end

  def add_bonus_score
    return if args.state.bonus_added
    args.state.score += 50
    args.state.bonus_added = true
  end

  def boss_dead?
    args.state.final_boss.hp <= 0
  end

  def player_has_been_hit?
    args.state.player.hit_by_bullet?(args)
  end

  def reset_state_for_new_attempt
    args.state.final_boss = nil
    args.state.bullets = []
    args.state.fireballs = []
    args.state.timer_at_start_level = args.state.timer
    args.state.player.alive = true
    # Seems to be fixed
    #args.state.saucers = [] # Don't know why it is need here - saucers is nil anyway when this scene begins for the first time
  end
end
