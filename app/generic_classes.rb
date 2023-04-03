class Sprite
  attr_sprite

  def primitive_marker
    :sprite
  end

  def serialize
    raise StandardError, "#{self.class}#serialize not implemented"
  end

  def inspect
    serialize.to_s
  end

  def to_s
    serialize.to_s
  end
end

class SceneNotImplError < StandardError; end

class Scene
  attr_reader :args

  def initialize(args)
    @args = args
  end

  def tick
    raise SceneNotImplError, "#{self.class}#tick method not implemented"
  end

  def inc_timer!
    if args.state.timer && args.state.tick_count % FPS == 0
      args.state.timer += 1
    end
  end

  def serialize
    {class: self.class, tick: args.state.tick_count}
  end

  def inspect
    serialize.to_s
  end

  def to_s
    serialize.to_s
  end
end
