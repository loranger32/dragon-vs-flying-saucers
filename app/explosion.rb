class Explosion < Sprite
  SIZE = 64
  DURATION = 7

  attr_accessor :dead, :birth

  def self.animate(args)
    args.state.explosions.each { _1.animate(args) }
  end

  def initialize(x: , y:, birth:)
    @x = x
    @y = y
    @w = SIZE
    @h = SIZE
    @dead = false
    @birth = birth
  end

  def animate(args, repeat = false)
    sprite_index = birth.frame_index(count: DURATION, hold_for: 2, repeat: repeat)
    if sprite_index.nil?
      self.dead = true
      return
    end

    self.path = "sprites/fireball_explosion/explosion-#{sprite_index}.png"
  end

  def serialize
    {x: x, y: y, w: w, h: h, path: path, dead: dead}
  end
end
