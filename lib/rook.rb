
class Rook
  attr_accessor :team, :valid_moves, :first_move
  def initialize(board, starting_position, player)
    #possible changes in position
    @board = board
    @team = player
    @vectors = {}
    create_vectors()
    @valid_moves = nil
    @current_position = starting_position
    valid_moves_check()
    @chess_board = board.chess_board
    @first_move = true
  end

  def create_vectors
    up = []
    down = []
    right = []
    left = []
    (1..7).each do |num|
      up << Vector.new(0, num)
      down << Vector.new(0, -num)
      right << Vector.new(num, 0)
      left << Vector.new(-num, 0)
    end
    @vectors[:up] = up
    @vectors[:down] = down
    @vectors[:right] = right
    @vectors[:left] = left
  end


  #put in player?
  def set_piece()
    @board.set_piece(@current_position, self)
  end

  def valid_moves_check()
    valid_move = []
    @vectors.each do |direction, direction_vectors|
      direction_vectors.each do |vector|
        position2 = vector.new_position(@current_position)
        #if in range of board, and not on own team piece, 
        if position2.on_board? && @board.get_piece(position2) == nil || position2.on_board? && @board.get_piece(position2).team != @team
          valid_move << position2
        end
        #stop iterating that direction if vector is off board or blocked
        break if !position2.on_board?  || @board.get_piece(position2) != nil
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
    @first_move = false
  end
end

=begin
board = ChessBoard.new 
player = Player.new('player1', 'black', 'bottom', board)
player2 = Player.new('player2', 'white', 'bottom', board)
bishop = Bishop.new(board, Position.new(7, 2), player)
bishop.set_piece
rook = Rook.new(board, Position.new(2, 2), player2)
rook.set_piece
p rook.valid?(Position.new(2, 1))
board.print_board
=end