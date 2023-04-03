class Bullet < Sprite
  attr_accessor :dead, :vect
  attr_reader :speed

  SIZE = 12

  def self.move(bullets)
    bullets.each(&:move)
    bullets.reject!(&:dead)
  end

  def initialize(x, y, speed, vect=nil)
    @x = x
    @y = y
    @w = SIZE
    @h = SIZE
    @angle = 0
    @path = "sprites/red.png"
    @speed = speed
    @dead = false
    @vect = vect || 0.to_vector(speed)
  end

  def move
    self.x -= vect.x
    self.y -= vect.y
    self.angle += 10

    self.dead = true if out?
  end

  def out?
    x <= -10 || x >= 1210 || y <= -10 || y >= 730
  end

  def serialize
    {x: x, y: y, dead: dead, speed: speed, vect: vect}
  end
end
