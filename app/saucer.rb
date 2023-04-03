class Saucer < Sprite
  SIZE = 64
  PATH = "sprites/flying-saucer-0.png"
  SPEED = 4

  attr_accessor :dead, :speed

  def self.init_saucers(args, num)
    saucers = []

    num.times do |i|
      ns = spawn_saucer(args, false, x: args.grid.w + SIZE + (65 * i))

      while saucers.any? { |existing| args.geometry.intersect_rect?(existing, ns) }
        ns = spawn_saucer(args, false)
      end

      saucers << ns
    end

    saucers
  end

  def self.animate(saucers)
    saucers.each(&:animate)
  end

  def self.move(saucers)
    saucers.each(&:move)
  end

  def self.shoot(args, speed)
    args.state.saucers.each { _1.shoot(args, speed) }
  end

  def self.spawn_saucer(args, check_intersect = true, x: nil)
    x ||= args.grid.w + SIZE
    y = rand(args.grid.h - SIZE*2)
    
    ns = new(x: x, y: y)

    return ns unless check_intersect

    while args.state.saucers&.any? { |existing| args.geometry.intersect_rect?(existing, ns) }
      ns = spawn_saucer(args, true, x: ns.x + SIZE + 1)
    end

    ns
  end

  def initialize(x:, y:, w: SIZE, h: SIZE)
    @x = x
    @y = y
    @w = w
    @h = h
    @path = PATH
    @dead = false
    @speed = SPEED
  end

  def animate
    sprite_index = 0.frame_index(count: 6, hold_for: 4, repeat: true)
    self.path = "sprites/flying-saucer-#{sprite_index}.png"
  end

  def move
    self.x -= speed
    self.dead = out?
  end

  def out?
    x < 0 - w
  end

  def shoot(args, speed)
    bullet = Bullet.new(x, y + 25, speed)

    if args.state.bullets_aimed
      theta = Math.atan2(y - args.state.player.y, x - args.state.player.x)
      vect = theta.to_degrees.to_vector(speed)
      bullet.vect = vect
    end
    
    args.state.bullets << bullet 
  end

  def serialize
    {x: x, y: y, w: w, h: h, path: path, dead: dead, speed: speed}
  end
end
