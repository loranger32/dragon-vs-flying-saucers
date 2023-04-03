# Player inputs
def fire_input?(args)
  args.inputs.keyboard.key_down.q || args.inputs.controller_one.key_down.a
end

def down?(args)
  !!args.inputs.down
end

def up?(args)
  !!args.inputs.up
end

def left?(args)
  !!args.inputs.left
end

def right?(args)
  !!args.inputs.right
end

def move_x?(args)
  left?(args) || right?(args)
end

def move_y?(args)
  up?(args) || down?(args)
end

# Labels
def h_centered_label(text:, se:, y:, color: nil)
  text_w, _ = $gtk.calcstringbox(text, se)
  label = {
    x: ($args.grid.w / 2) - (text_w / 2),
    y: y,
    text: text,
    size_enum: se
  }
  label.merge(color) if color
end

# Credits utils
class VSpacer
  attr_reader :y

  def initialize(source_y)
    @y = source_y
  end

  def -(delta_y)
    @y -= delta_y
  end

  def +(delta_y)
    @y += delta_y
  end

  def set_to(new_y)
    @y = new_y
  end
end

# COLORS - From Scale https://github.com/DragonRidersUnite/scale/tree/main/app
TRUE_BLACK = { r: 0, g: 0, b: 0 }
BLACK = { r: 25, g: 25, b: 25 }
GRAY = { r: 157, g: 157, b: 157 }
WHITE = { r: 255, g: 255, b: 255 }

BLUE = { r: 42, g: 133, b: 216 }
GREEN = { r: 42, g: 216, b: 78 }
ORANGE = { r: 255, g: 173, b: 31 }
PINK = { r: 245, g: 146, b:  198 }
PURPLE = { r: 133, g: 42, b: 216 }
RED = { r: 231, g: 89, b: 82 }
YELLOW = { r: 240, g: 232, b: 89 }

DARK_BLUE = { r: 22, g: 122, b: 188 }
DARK_GREEN = { r: 5, g: 84, b: 12 }
DARK_PURPLE = { r: 66, g: 12, b: 109 }
DARK_PURPLE = { r: 103, g: 5, b: 98 }
DARK_RED = { r: 214, g: 26, b: 12 }
DARK_YELLOW = { r: 120, g: 97, b: 7 }

# Temporary hack
def white
  WHITE
end