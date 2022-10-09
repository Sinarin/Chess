
class Knight
  #all the possible directions(vectors) a knight can move
  attr_accessor :team
  def initialize(board, starting_position, player)
    #possible changes in position
    @vectors = [Vector.new(2, 1), Vector.new(2, -1), Vector.new(-2, 1), Vector.new(-2, -1), Vector.new(1, 2), Vector.new(1, -2), Vector.new(-1, 2), Vector.new(-1, -2)]
    @board = board
    @team = player
    @valid_moves = nil
    @current_position = starting_position
    valid_moves_check()
    @chess_board = board.chess_board
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
    @valid_moves = valid_move
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

=begin
board = ChessBoard.new 
player = Player.new('player1', 'black', 'bottom', board)
knight = Knight.new(board, Position.new(1, 1), player)
knight.set_piece
board.print_board
knight.move(Position.new(2, 3)) if knight.valid?(Position.new(2, 3))
board.print_board
=end