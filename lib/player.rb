require_relative 'board'
require_relative 'pawn'
require_relative 'vector'
require_relative 'bishop'
require_relative 'knight'
require_relative 'queen'
require_relative 'rook'
require_relative 'queen'
require_relative 'king'

class Player
  attr_accessor :colour, :side, :alive
  def initialize(name, colour, side, board, opponent = nil)
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
    #do any of the opponnet move a have a valid move to your king
    #if the current move goes through.
    @opponent.alive.each do |piece|
      piece.valid_moves_check
      if piece.valid_moves.any? {|position| position.same_values?(@king_position)}
        return true
      end
    end
  end

  def checkmate?
    #can any of playsers pieces make a move that results in check being false .. 
    #create a sim board for every possible move
    @alive.each do |piece|
      piece.valid_moves_check
      piece.valid_moves.each do |move|
        sim_board = Marshal.load(Marshal.dump(@board))
        sim_piece = sim_board.get_piece(piece.current_position)
        sim_piece.move(move)
        return false if !sim_piece.team.check?
      end
    end
    true   
  end

end

board = ChessBoard.new 
player = Player.new('player1', 'black', 'top', board)
player2 = Player.new('player2', 'white', 'bottom', board)
bishop = Bishop.new(board, Position.new(7, 2), player)
bishop.set_piece
rook = Rook.new(board, Position.new(7, 7), player2)
rook.set_piece
simboard = Marshal.load(Marshal.dump(board))
p simboard.chess_board[[7, 2]].piece == board.chess_board[[7, 2]].piece

#to test check mate use two rooks... first... maybe in rspec