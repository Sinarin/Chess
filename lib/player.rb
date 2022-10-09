class Player
  attr_accessor :colour, :side, :alive
  def initialize(name, colour, side, board, opponent)
    @board = board
    @name = name
    @opponent = opponent
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

  def check?
    #do any of the opponenet move a have a valid move to your king
    #if the current move goes through.
    @opponent.alive.each do |piece|
      piece.valid_moves
      if pe
  end
end

