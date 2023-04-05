class Fireball < Sprite
  LAUNCH = "sounds/fireball.wav"
  BOOM = "sounds/target.wav"
  PATH = "sprites/fireball.png"
  SIZE = 32
  SPEED = 12

  attr_accessor :dead

  def self.shoot(args)
    args.state.fireballs << new(args.state.player)
    args.outputs.sounds << "sounds/fireball.wav"
  end

  def self.move(args)
    args.state.fireballs.each do |fb| 
      fb.move
  
      if fb.out?
        fb.dead = true
        next
      end
      
      if (saucer = fb.hit_saucer(args))
        fb.blast(args, saucer)
      end
    end
  end

  def self.move_final_boss(args)
    args.state.fireballs.each do |fb|
      fb.move

      if fb.out?
        fb.dead = true
        next
      end

      if fb.intersect_rect?(args.state.final_boss)
        args.outputs.sounds << BOOM
        fb.dead = true
        args.state.final_boss.hp -= 1
        args.state.explosions << Explosion.new(x: fb.x, y: fb.y, birth: args.state.tick_count)
      end
    end

    args.state.fireballs.reject!(&:dead)
  end

  def initialize(player)
    @x = player.x + player.w - 12
    @y = player.y + 3
    @w = SIZE
    @h = SIZE
    @path = PATH
    @dead = false
  end

  def serialize
    {x: x, y: y, w: w, h: h, path: path, dead: dead}
  end

  private

  def blast(args, saucer)
    self.dead = true
    saucer.dead = true
    args.state.score += 1
    args.outputs.sounds << BOOM
    args.state.explosions << Explosion.new(x: saucer.x, y: saucer.y, birth: args.state.tick_count)
  end

  def hit_saucer(args)
    hit = args.state.saucers.select { |saucer| saucer.intersect_rect?(self) }
    hit.empty? ? nil : hit.first
  end

  def move
    self.x += SPEED
  end

  def out?
    x > 1200 + w
  end
end
