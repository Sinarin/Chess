=begin
require_relative 'board'
require_relative 'pawn'
require_relative 'vector'
require_relative 'bishop'
require_relative 'knight'
require_relative 'queen'
require_relative 'rook'
require_relative 'queen'
require_relative 'king'
=end

class Player
  attr_accessor :colour, :side, :alive, :opponent, :king
  def initialize(name, colour, side, board, opponent = nil)
    @board = board
    @name = name
    @opponent = opponent
    @colour = colour
    @side = side
    @alive = []
    @dead = []
    @king = nil
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
      #are there any moves that opponent piece can do to land on the current king position
      if piece.valid_moves.any? {|position| position.same_values?(self.king.current_position)}
        return true
      end
    end
    false
  end

  def simulate_move_for_check?(move, piece)
    sim_board = Marshal.load(Marshal.dump(@board))
    sim_piece = sim_board.get_piece(piece.current_position)
    sim_piece.move(move)
    sim_piece.team.check?
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

=begin
board = ChessBoard.new 
player = Player.new('player1', 'black', 'top', board)
player2 = Player.new('player2', 'white', 'bottom', board, player)
player.opponent = player2
rook1 = Rook.new(board, Position.new(2, 3), player)
rook1.set_piece
rook = Rook.new(board, Position.new(1, 1), player)
rook.set_piece
king = King.new(board, Position.new(7,1), player2)
king.set_piece
player.alive << rook1
player.alive << rook
player2.alive << king
player2.king = king
p player2.check?
p player2.checkmate?
p player2.simulate_move_for_check?(Position.new(7,2), king)

#to test check mate use two rooks... first... maybe in rspec
=end