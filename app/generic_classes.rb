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
  attr_reader :args, :gain

  def initialize(args)
    @args = args
    @gain = $gtk.production? ? 1.0 : 0.2
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

  def debug_labels
    return if args.gtk.production?

    args.outputs.debug << {x: 40, y: 80, text: "Timer: #{args.state.timer}"}.merge(white)
    args.outputs.debug << {x: 40, y: 40, text: "FR: #{args.gtk.current_framerate}"}.merge(white)
  end
end
