require_relative 'board'
require_relative 'player'
require_relative 'vector'
require_relative 'bishop'
require_relative 'knight'
require_relative 'queen'
require_relative 'rook'
require_relative 'queen'
require_relative 'king'

class Pawn
  attr_accessor :team, :en_passant

  def initialize(board, starting_position, player)
    @board = board
    @starting_position = starting_position
    @team = player
    @first_move = true 
    @movement_vectors = movement_vectors(player)
    @attack_vectors = [Vector.new(1, @movement_vectors.y), Vector.new(-1, @movement_vectors.y)]
    @special_move = Vector.new(0, 2 * @movement_vectors.y)
    @en_passant = nil
    @current_position = starting_position
    @valid_moves = []
    valid_moves()
    @promotion_positions = []
    promotion_positions(player)
  end

  def set_piece()
    @board.set_piece(@current_position, self)
  end

  def promotion_positions(player)
    if player.side == "bottom"
      for i in 1..8
        @promotion_positions << Position.new(i, 8)
      end
    elsif player.side == "top"
      for i in 1..8
        @promotion_positions << Position.new(i, 1)
      end
    end
  end

  def promotion?
    @promotion_positions.each do |position|
      if position.same_values?(@current_position)
        return true
      end
    end
  end
  #need to not allow going on same team pieces...add later
  def movement_vectors(player)
    if player.side == "bottom"
      Vector.new(0, 1)
    elsif player.side == "top"
      Vector.new(0, -1)
    end
  end

  def valid_moves()
    valid_move = []
    #add double move
    valid_move << @special_move.new_position(@current_position) if @first_move
    #add attack moves
    @attack_vectors.each do |vector|
      position2 = vector.new_position(@current_position)
      if position2.on_board? && @board.get_piece(position2) != nil && @board.get_piece(position2).team == @team
        valid_move << position2
      end
    end
    #add normal moves
    pos3 = @movement_vectors.new_position(@current_position)
    valid_move << pos3 if pos3.on_board? && @board.get_piece(pos3) == nil
    #add en passant
    valid_move << @en_passant if @en_passant != nil

    @valid_moves = valid_move 
  end

  def valid?(position)
    @valid_moves.each do |move|
      return true if move.same_values?(position)
    end
    false
  end

  def en_passant_used (position)
    if @en_passant && position.same_values?(@en_passant)
      @en_passant = nil
      @board.set_piece(Vector.new(@movement_vectors.x, @movement_vectors.y * -1).new_position(@current_position), nil)
    end
  end

  def special_move_used(position)
    if position.same_values?(@special_move.new_position(@starting_position))
      right_piece = @board.get_piece(Vector.new(1, 0).new_position(@current_position)) if Vector.new(1, 0).new_position(@current_position).on_board?
      left_piece = @board.get_piece(Vector.new(-1, 0).new_position(@current_position)) if Vector.new(-1, 0).new_position(@current_position).on_board?
      #if right of current position is enemy team give that piece the ability(position) to enpassant same with left....
      if left_piece != nil && left_piece.class == Pawn && left_piece.team != @team
        left_piece.en_passant = @movement_vectors.new_position(@starting_position)
      end
      if right_piece != nil && right_piece.class == Pawn && right_piece.team != @team
        right_piece.en_passant = @movement_vectors.new_position(@starting_position)
      end
    end
  end 

  def move(position)
    @board.set_piece(@current_position, nil)
    @board.set_piece(position, self)
    @current_position = position
    @first_move = false
    special_move_used(position)
    en_passant_used(position)
  end

end


=begin
board = ChessBoard.new 
player = Player.new('player1', 'black', 'top', board)
player2 = Player.new('player2', 'white', 'bottom', board)
bishop = Bishop.new(board, Position.new(7, 2), player)
bishop.set_piece
rook = Rook.new(board, Position.new(7, 7), player2)
rook.set_piece
pawn = Pawn.new(board, Position.new(2, 5), player2)
pawn.set_piece
pawn2 = Pawn.new(board, Position.new(1, 7), player)
pawn2.set_piece
board.print_board
pawn2.move(Position.new(1, 6)) if pawn2.valid?(Position.new(1, 6))
board.print_board
pawn.valid_moves()
board.print_board
pawn.move(Position.new(1, 6)) if pawn2.valid?(Position.new(1, 6))
board.print_board
=end

