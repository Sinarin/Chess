require_relative 'board'
require_relative 'player'
require_relative 'vector'
require_relative 'bishop'
require_relative 'pawn'
require_relative 'knight'
require_relative 'queen'
require_relative 'rook'


#need to add a check for check
class King
  attr_accessor :team
  def initialize(board, starting_position, player)
    #possible changes in position
    @board = board
    @team = player
    @vectors = []
    create_vectors()
    @valid_moves = nil
    @current_position = starting_position
    valid_moves()
    @chess_board = board.chess_board
    @first_move = true
  end
  #maybe just set the vector manually...
  def create_vectors
    num = 1
    @vectors << Vector.new(0, num)
    @vectors << Vector.new(0, -num)
    @vectors << Vector.new(num, 0)
    @vectors << Vector.new(-num, 0)
    @vectors << Vector.new(num, num)
    @vectors << Vector.new(-num, -num)
    @vectors << Vector.new(num, -num)
    @vectors << Vector.new(-num, num)
  end


  #put in player?
  def set_piece()
    @board.set_piece(@current_position, self)
  end

  def valid_moves()
    valid_moves = []
    @vectors.each do |vector|
      position2 = vector.new_position(@current_position)
      #if in range of board, and not on own team piece, 
      if position2.on_board? && @board.get_piece(position2) == nil || position2.on_board? && @board.get_piece(position2).team != @team
        valid_moves << position2
      end
    end
    @valid_moves = valid_moves
  end

  def valid?(position)
    @valid_moves.each do |move|
      return true if move.same_values?(position)
    end
    false
  end

  def move(position)
    @board.set_piece(@current_position, nil)
    @board.set_piece(position, self)
    @current_position = position
  end
end


board = ChessBoard.new 
player = Player.new('player1', 'black', 'bottom', board)
player2 = Player.new('player2', 'white', 'bottom', board)
bishop = Bishop.new(board, Position.new(7, 2), player)
bishop.set_piece
king = King.new(board, Position.new(2, 2), player2)
king.set_piece
p king.valid?(Position.new(4, 4))
board.print_board