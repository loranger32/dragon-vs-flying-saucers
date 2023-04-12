class Background < Sprite
  def initialize(path)
    @x = 0
    @y = 0
    @w = $gtk.args.grid.w
    @h = $gtk.args.grid.h
    @a = 255
    @path = path
  end

  def serialize
    {x: x, y: y, w: w, h: h, a: a, path: path, class: self.class}
  end
end
