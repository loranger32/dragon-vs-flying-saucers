class FinalBoss < Sprite
  WIDTH = 200
  HEIGHT = 200
  HP = 50
  PATH = "sprites/alienshiptex.png"
  attr_accessor :alive, :death_tick, :hp

  def initialize(x:, y:, w: WIDTH, h: HEIGHT)
    @x = x
    @y = y
    @w = w
    @h = h
    @hp = HP
    @path = PATH
    @alive = true
    @up = true
  end

  def animate_explosion(args)
    sprite_index = death_tick.frame_index(count: 16, hold_for: 8, repeat: false)

    if sprite_index.nil?
      args.state.final_boss_explosion_finished = true
      return
    end

    self.path = "sprites/big_explosion/big_explosion-#{sprite_index + 1}.png"
  end

  def shoot(args)
    return if args.state.tick_count == 0

    if args.state.tick_count % fire_rate == 0
      # Horizontal bullets
      args.state.bullets << Bullet.new(x, y, 10)
      args.state.bullets << Bullet.new(x, y + h / 2, 10)
      args.state.bullets << Bullet.new(x, y + h, 10)

      # Diagonal bullets
      args.state.bullets << Bullet.new(x, y, 10, 40.to_vector(10))
      args.state.bullets << Bullet.new(x, y, 10, 30.to_vector(10))
      args.state.bullets << Bullet.new(x, y + h / 2, 10, 20.to_vector(10))
      args.state.bullets << Bullet.new(x, y + h / 2, 10, 10.to_vector(10))
      args.state.bullets << Bullet.new(x, y + h / 2, 10, -10.to_vector(10))
      args.state.bullets << Bullet.new(x, y + h / 2, 10, -20.to_vector(10))
      args.state.bullets << Bullet.new(x, y + h, 10, -30.to_vector(10))
      args.state.bullets << Bullet.new(x, y + h, 10, -40.to_vector(10))
    end
  end

  def almost_dead?
    @hp < 20
  end

  def fire_rate
    almost_dead? ? 90 : 120
  end

  def move(args)
    if up?
      self.y += 5
    else
      self.y -= 5
    end

    if y > 520
      @up = false
    elsif y < 50
      @up = true
    end
  end

  def up?
    @up
  end

  def down?
    !@up
  end

  def serialize
    {x: x, y: y, w: w, h: h, path: path, alive: alive, hp: hp}
  end
end
