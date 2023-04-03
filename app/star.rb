class Star < Sprite
  attr_reader :variation_dir

  SIZE = 25
  PATH = "sprites/star.png"

  def self.populate_sky(args, qty)
    sky = []
    qty.times do |i|
      x = rand(1300)
      y = rand(700)
      a = (i * 2 + 35) % 255
      sky << new(x, y, a)
    end
    sky
  end

  def self.animate(stars)
    stars.each(&:change_alpha)
  end

  def initialize(x, y, a)
    @x = x
    @y = y
    @w = SIZE
    @h = SIZE
    @path = PATH
    @a = a
    @variation_dir = :up
  end

  def change_alpha
    if variation_dir == :up
      @a += 1
    elsif variation_dir == :down
      @a -= 1
    else
      raise "No direction provided for star"
    end

    @variation_dir = :up if @a <= 34
    @variation_dir = :down if @a >= 221
  end

  def serialize
    {class: self.class, x: x, y: y, w: w, h: h, path: path, variation_dir: variation_dir}
  end
end
