class Player
  attr_reader :colour
  def initialize(name, colour, side, board)
    @board = board
    @name = name
    @colour = colour
    @side = side
    @alive = []
    @dead = []
  end

  def create_team
    if @side == "top"
      for i in 1..8
        Pawn.new(self, [i, 7], @board)
      end
    elsif @side == "bottom"
      for i in 1..8
        Pawn.new(self, [i, 2], @board)
      end
    end
  end
end

