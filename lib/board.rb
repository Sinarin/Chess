
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
    print " "
    ("a".."h").each { |letter| print " \u0332#{letter}"}
    print "\n"
    (0..7).each do |rank|
      print "#{8 - rank}|"
      (1..8).each do |file|
        if get_piece(Position.new(file, 8 - rank)) == nil
          print "_|"
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
    if piece.team.colour == "white"
      if piece.class == King
        "\u0332\u265A"
      elsif piece.class == Queen
        "\u0332\u265B"
      elsif piece.class == Rook
        "\u0332\u265C"
      elsif piece.class == Bishop
        "\u0332\u265D"
      elsif piece.class == Knight 
        "\u0332\u265E"
      elsif piece.class == Pawn
        "\u0332\u265F"
      end
    elsif piece.team.colour == "black"
      if piece.class == King
        "\u0332\u2654"
      elsif piece.class == Queen
        "\u0332\u2655"
      elsif piece.class == Rook
        "\u0332\u2656"
      elsif piece.class == Bishop
        "\u0332\u2657"
      elsif piece.class == Knight 
        "\u0332\u2658"
      elsif piece.class == Pawn
        "\u0332\u2659"
      end
    end
  end

  def to_fen_string
    fen = ""
    for y in 1..8
      space_count = 0
      for x in 1..8
        piece = @board[[x, y]].piece
        if piece == nil
          space_count += 0
          fen += "#{space_count}" if x == 8 
        else
          piece_class = @piece.class
          if piece_class == Knight
            if piece.team.colour == "black"
              fen += "n"
            else
              fen += "N"
            end
          else
            if piece.team.colour == "black"
              fen += piece_class.to_s[0].to_lower
            else
              fen += piece_class.to_s[0]
            end
          end
        end
      end
      fen += "/" unless y = 8
    end
    #add the rest of the fen string stuff....
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


