=begin
require_relative 'player'
require_relative 'pawn'
require_relative 'vector'
require_relative 'bishop'
require_relative 'knight'
require_relative 'queen'
require_relative 'rook'
require_relative 'queen'
require_relative 'king'
=end


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
    piece = @chess_board[[position.x, position.y]].piece
    #if a piece is in that spot already
    if piece && chess_piece
      team = piece.team
      team.dead << team.alive.delete(piece)
    end
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
    (1..8).reverse_each do |y|
      space_count = 0
      for x in 1..8
        piece = @chess_board[[x, y]].piece
        if piece == nil
          space_count += 1
          fen += "#{space_count}" if x == 8 
        else
          piece_class = piece.class
          if piece_class == Knight
            if piece.team.colour == "black"
              fen += "#{space_count}" if space_count > 0
              space_count = 0
              fen += "n"
            else
              fen += "#{space_count}" if space_count > 0
              space_count = 0
              fen += "N"
            end
          else
            if piece.team.colour == "black"
              fen += "#{space_count}"  if space_count > 0
              space_count = 0
              fen += piece_class.to_s[0].downcase
            else
              fen += "#{space_count}"  if space_count > 0
              space_count = 0
              fen += piece_class.to_s[0]
            end
          end
        end
      end
      fen += "/" unless y == 1
    end
    fen
  end

  def castle_rights(player)
    king = player.king
    #check castling rights
    fen_add_on = ""
    #queen side comes first so do reverse so king is iterated over first
    king.castling_vector.reverse_each do |vector|
      position2 = vector.new_position(king.current_position)
      if king.valid_moves.any? { |move| move.same_values?(position2)} && vector.x == 2
        fen_add_on += "K"
      elsif king.valid_moves.any? { |move| move.same_values?(position2)} && vector.x == -2
        fen_add_on += "Q"
      end
    end
    if player.colour == "black"
      fen_add_on.downcase
    else
      fen_add_on
    end
  end

  #add turn tracker...
  #half move and full move tracker

  
  
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

=begin
board = ChessBoard.new 
player = Player.new('player1', 'black', 'top', board)
player2 = Player.new('player2', 'white', 'bottom', board, player)
player.opponent = player2
player2.create_team
pawn = Pawn.new(board, Position.new(5, 5), player)
pawn.set_piece
rook = Rook.new(board, Position.new(8, 8), player)
rook.set_piece
rook1 = Rook.new(board, Position.new(1, 8), player)
rook1.set_piece
king = King.new(board, Position.new(5, 8), player)
king.set_piece
player.alive << rook
player.alive << rook1
player.alive << king
player.king = king
player.update_valid_moves
board.print_board
p board.to_fen_string
p board.castle_rights(player)
=end