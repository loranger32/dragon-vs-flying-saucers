class Cloud < Sprite
  BASE_SPEED = 1
  MIN_SIZE = 20
  RANDOM_SIZE = 80
  PATH = "sprites/cloud.png"

  attr_accessor :dead

  def self.init_clouds(args, num)
    clouds = []

    num.times do
      nc = spawn_random

      while clouds.any? { |existing| args.geometry.intersect_rect?(existing, nc) }
        nc = spawn_random
      end

      clouds << nc
    end

    clouds
  end

  def self.move_clouds(args)
    args.state.clouds.each do |cloud|
      cloud.move

      if cloud.x <= -cloud.w
        cloud.dead = true
        args.state.clouds << spawn_right(args)
      end
    end

    args.state.clouds.reject!(&:dead)
  end

  def self.spawn_right(args)
    nc = spawn_random
    nc.x = args.grid.w + nc.w

    while args.state.clouds.any? { |existing| args.geometry.intersect_rect?(existing, nc) }
      nc = spawn_right(args)
    end

    nc
  end

  def self.spawn_random
    size = rand(RANDOM_SIZE) + MIN_SIZE
    tw = 1200
    th = 720
    x = rand(tw - size*2) + (size / 2)
    y = rand(th - size*2) + (size / 2)

    new(x: x, y: y, w: size, h: size)
  end

  def initialize(x:, y:, w:, h:)
    @x    = x
    @y    = y
    @w    = w
    @h    = h
    @path = PATH
    @dead = false
    @speed = BASE_SPEED * [1,2].sample
  end

  def serialize
    {x: x, y: y, w: w, h: h, path: path, dead: dead}
  end

  def move
    self.x -= @speed
  end
end
