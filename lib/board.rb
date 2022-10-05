class ChessBoard
  attr_accessor :chess_board

  def initialize
    @chess_board = create_board()
  end

=begin
can do:
  chess_board = {}
  [*1..8].repeated_permutation(2).to_a.each do |pair|
    chess_board[pair] = Square.new([pair])
  end
=end
  def create_board
    chess_board = {}
    (1..8).each do |i| 
      (1..8).each do |f|
        chess_board[[i, f]] = Square.new([i, f])
      end
    end
    chess_board
  end

  def get_piece(position)
    @chess_board[[position.x, position.y]].piece
  end

  def set_piece(position, chess_piece)
    @chess_board[[position.x, position.y]].piece = chess_piece
  end

  def print_board
    (0..7).each do |rank|
      print "|"
      (1..8).each do |file|
        if get_piece(Position.new(file, 8 - rank)) == nil
          print " |"
        else
          print "#{piece_representation(get_piece(Position.new(file, 8 - rank)))}|"
        end
      end
      print "\n"
    end
    print "\n"
  end

  #maybe store this in each piece... 
  def piece_representation(piece)
    if piece.team.colour == "black"
      if piece.class == King
        "\u265A"
      elsif piece.class == Queen
        "\u265B"
      elsif piece.class == Rook
        "\u265C"
      elsif piece.class == Bishop
        "\u265D"
      elsif piece.class == Knight 
        "\u265E"
      elsif piece.class == Pawn
        "\u265F"
      end
    elsif piece.team.colour == "white"
      if piece.class == King
        "\u2654"
      elsif piece.class == Queen
        "\u2655"
      elsif piece.class == Rook
        "\u2656"
      elsif piece.class == Bishop
        "\u2657"
      elsif piece.class == Knight 
        "\u2658"
      elsif piece.class == Pawn
        "\u2659"
      end
    end
  end

end


class Square
  attr_reader :value 
  attr_accessor :adjacent_nodes, :piece
  def initialize(value = nil)
    @value = value
    @adjacent_nodes = []
    @piece = nil
  end

  def add_edge(node)
    @adjacent_nodes << node
  end
end


