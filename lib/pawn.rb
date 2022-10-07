require_relative 'board'
require_relative 'player'

class Pawn

  Vector = Struct.new(:x, :y)

  def initialize(player, starting_position, board)
    @board = board
    @board.chess_board[starting_position].piece = self
    @starting_position = starting_position
    @team = player.team
    @first_move = true 
    @movement_vectors = movement_vectors(player)
    @attack_vectors = [[1, @movement_vectors[1]], [-1, @movement_vectors[1]]]
    @special_move = [0, 2 * @movement_vectors[1]]
    @en_passant = nil
    @current_position = starting_position
    @valid_moves = []
  end

  #need to not allow going on same team pieces...add later
  def movement_vectors(player)
    if player.side == "bottom"
      [0, 1]
    elsif player.side == "top"
      [0, -1]
    end
  end

  def valid_moves
    @valid_moves << @special_move.new_position(@current_position) if @first_move
    @attack_vectors.each do |vector|
      position2 = vector.new_position(@current_position)
      if position2.on_board? && position2
        @valid_moves << 
  end

=begin
  def valid_move?(position)
    #if position given is current postion plus movement vector and not taken
    if @board.chess_board[position].piece == nil && @current_position[1] + @movement_vectors[1] == position[1] &&
      @current_position[0] == position[0] 
      true
    #attack a piece... 
    elsif @board.chess_board[position].piece != nil && @current_position[1] + @movement_vectors[1] == position[1] &&
      @current_position[0] == position[0] 
      
    end
  end


  def check_move(position)
    if position[0].between?(1, 8) && position[1].between?(1, 8)
      input_vector = [position[0] - current_position[0], position [1] - current_position[1]]

      if input_vector == @movement_vectors && @board.chess_board[position].piece == nil
        move(position)
        return position
      elsif input_vector == @special_move && @board.chess_board[position].piece == nil &&
        @board.chess_board[position[0], position[1] - movement_vectors[1]] == nil
        move(position)
        return position
      elsif @en_passant == position && @en_passant != nil
        move(position)
        @board.chess_board[position[0], position[1] - @movement_vectors[1]].piece = nil
        return position
      end

      @attack_vectors.each do |vector|
        if input_vector == vector && position != nil
          move(position)
          return position
        end
      end
    end
  end


  def attack
    @attack_vectors.each do |vector|
      x = vector[0] + current_position[0]
      y = vector[1] + current_position[1]
      @valid_moves << [x, y] if @board.chess_board[[x, y]].piece != nil
    end
  end

  def en_passant
    if @en_passant != nil
      @valid_moves << en_passant
    end
  end

  def special_move
    if first_move 
      x = special_move[0] + current_position[0]
      y = special_move[1] + current_position[1]
      @valid_moves << [x, y] if @board.chess_board[[x, y]].piece == nil
    end
  end

  #same as above for normal move make that method

  def move(position)
    @board.chess_board[position].piece = self
  end
=end
end