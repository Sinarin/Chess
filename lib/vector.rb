class Vector
  attr_accessor :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def same_values?(v2)
    @x == v2.x &&  @y == v2.y
  end

  def new_position(position)
    position2 = Position.new(position.x + @x, position.y + @y)
  end


end

class Position
  attr_accessor :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def same_values?(v2)
    @x == v2.x &&  @y == v2.y
  end

  def on_board?
    @x.between?(1, 8) && @y.between?(1, 8)
  end

  
end