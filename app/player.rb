class Player < Sprite
  WIDTH = 60
  HEIGHT = 55
  ORT_SPEED = 10
  DIAG_SPEED = 6
  STATIC_ANIMATION_RATE = 8
  MOVEMENT_ANIMATION_RATE = 4
  EXPLOSION_W = 96

  attr_accessor :alive, :death_tick

  def initialize(x:, y:, w: WIDTH, h: HEIGHT)
    @x = x
    @y = y
    @w = w
    @h = h
    @alive = true
  end

  def animate_explosion(args)
    sprite_index = death_tick.frame_index(count: 5, hold_for: 8, repeat: false)
    self.path = "sprites/dragon_explosion/dragon-explosion-#{sprite_index}.png"

    if sprite_index.nil?
      args.state.timer = 0
      args.state.player_explosion_finished = true
      self.path = "sprites/dragon_explosion/dragon-explosion-11.png"
    end
  end

  def animate_sprite(args)
    sprite_index = 0.frame_index(count: 6, hold_for: animation_speed(args), repeat: true)
    self.path = "sprites/dragon/dragon-#{sprite_index}.png"
  end

  def animation_speed(args)
    if move_x?(args) || move_y?(args)
      MOVEMENT_ANIMATION_RATE
    else
      STATIC_ANIMATION_RATE
    end
  end

  def check_boundaries(grid)
    self.x = x.clamp(0, grid.w - w)
    self.y = y.clamp(0, grid.h - h)
  end

  def hit_by_saucer?(args)
    args.state.saucers&.any? { |saucer| saucer.intersect_rect?(self, 8.0) }
  end

  def hit_by_bullet?(args)
    args.state.bullets&.any? { |bullet| bullet.intersect_rect?(self, 5.0) }
  end

  def move(args)
    speed = speed(args)

    if left?(args)
      self.x -= speed
    elsif right?(args)
      self.x += speed
    end

    if down?(args)
      self.y -= speed
    elsif up?(args)
      self.y += speed
    end

    check_boundaries(args.grid)

    if hit_by_saucer?(args) || hit_by_bullet?(args)
      self.alive = false
      self.death_tick = args.state.tick_count
      args.audio[:music].paused = true
      args.outputs.sounds << "sounds/death.wav"
    end
  end

  def serialize
    {x: x, y: y, w: w, h: h, path: path, alive: alive}
  end

  def speed(args)
    if move_x?(args) && move_y?(args)
      DIAG_SPEED
    else
      ORT_SPEED
    end
  end
end
