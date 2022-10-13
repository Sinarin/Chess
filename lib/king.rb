=begin
require_relative 'board'
require_relative 'pawn'
require_relative 'vector'
require_relative 'bishop'
require_relative 'knight'
require_relative 'queen'
require_relative 'rook'
require_relative 'queen'
require_relative 'player'
=end

#need to add a check for check
class King
  attr_accessor :team, :valid_moves, :current_position, :first_move
  def initialize(board, starting_position, player)
    #possible changes in position
    @board = board
    @team = player
    @vectors = []
    @castling_vector = []
    create_vectors()
    @valid_moves = nil
    @current_position = starting_position
    @starting_position = starting_position
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
    @castling_vector << Vector.new(-2, 0)
    @castling_vector << Vector.new(2, 0)
  end


  #put in player?
  def set_piece()
    @board.set_piece(@current_position, self)
  end

  def valid_moves_check()
    valid_move = []
    @vectors.each do |vector|
      position2 = vector.new_position(@current_position)
      #if in range of board, and not on own team piece, 
      if position2.on_board? && @board.get_piece(position2) == nil || position2.on_board? && @board.get_piece(position2).team != @team
        valid_move << position2
      end
    end

    @castling_vector.each do |vector|
      position2 = vector.new_position(@current_position)
      #if in range of board, and not on own team piece, 
      #for left
      if vector.x == -2 && @first_move == true && left_rook_first_move? && !@team.check? && left_path_clear?
         !@team.simulate_move_for_check?(Position.new(-1 + @current_position.x, @current_position.y), self) && !@team.simulate_move_for_check?(Position.new(-2 + @current_position.x, @current_position.y), self)
        valid_move << position2
      elsif vector.x == 2 && @first_move == true && right_rook_first_move? && !@team.check? && right_path_clear?
        !@team.simulate_move_for_check?(Position.new(1 + @current_position.x, @current_position.y), self) && !@team.simulate_move_for_check?(Position.new(2 + @current_position.x, @current_position.y), self)
        valid_move << position2
      end
    end

    @valid_moves = valid_move
  end

  def right_path_clear?
    !@board.get_piece(Position.new(6, @starting_position.y)) && !@board.get_piece(Position.new(7, @starting_position.y))
  end

  def left_path_clear?
    !@board.get_piece(Position.new(2, @starting_position.y)) && !@board.get_piece(Position.new(3, @starting_position.y)) &&
    !@board.get_piece(Position.new(4, @starting_position.y))
  end

  def left_rook_first_move?
    @board.get_piece(Position.new(1, @current_position.y)).first_move if @board.chess_board[[1, @current_position.y]] && @first_move == true
  end

  def right_rook_first_move?
    @board.get_piece(Position.new(8, @current_position.y)).first_move if @board.chess_board[[8, @current_position.y]] && @first_move == true
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
    @first_move = false
    if position.same_values?(Vector.new(2, 0).new_position(@starting_position))
      @board.get_piece(Position.new(8, @starting_position.y)).move(Position.new(6, @starting_position.y))
    elsif position.same_values?(Vector.new(-2, 0).new_position(@starting_position))
      @board.get_piece(Position.new(1, @starting_position.y)).move(Position.new(4, @starting_position.y))
    end
  end
end

=begin
board = ChessBoard.new 
player = Player.new('player1', 'black', 'top', board)
player2 = Player.new('player2', 'white', 'bottom', board, player)
player.opponent = player2
bishop = Bishop.new(board, Position.new(7, 1), player)
bishop.set_piece
rook = Rook.new(board, Position.new(8, 1), player2)
rook.set_piece
rook1 = Rook.new(board, Position.new(1, 1), player2)
rook1.set_piece
king = King.new(board, Position.new(5, 1), player2)
king.set_piece
player.alive << bishop
player2.alive << rook
player2.alive << rook1
player2.alive << king
player2.king = king
king.valid_moves_check()

p king.valid_moves
king.move(Position.new(3, 1)) if king.valid?(Position.new(3, 1))
board.print_board
=end
