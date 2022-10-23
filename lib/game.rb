
require_relative 'board'
require_relative 'pawn'
require_relative 'vector'
require_relative 'bishop'
require_relative 'knight'
require_relative 'queen'
require_relative 'rook'
require_relative 'queen'
require_relative 'king'
require_relative 'player'


class Game
  attr_accessor :en_passant_black, :en_passant_white

  def initialize
    @count50 = 0
    @count100 = 0
    @turn = nil
    @board = nil
    @en_passant_black = nil
    @en_passant_white = nil
    @player1 = nil
    @player2 = nil
  end

  def start_game
    #add a method that asks player one what side...
    board = ChessBoard.new 
    @board = board
    player1 = Player.new('player1', 'white', 'top', board)
    @turn = player1
    player2 = Player.new('player2', 'black', 'bottom', board, player1)
    player1.opponent = player2
    @player1 = player1
    @player2 = player2
    player1.game = self
    player2.game = self
    player1.opponent = player2
    player1.create_team
    player2.create_team
    player1.update_valid_moves
    board.print_board
    p to_fen_string()

    while 
      #add counter in here to count for statemate
      turn(player1)
      player1.update_valid_moves
=begin
      p player2.check?
=end
      break if player2.checkmate? || statemate?()
      turn(player2)
      player2.update_valid_moves
=begin
      p player1.check?
=end
      break if player1.checkmate? || statemate?()
    end

    if player1.checkmate?
      you_win(player2)
    elsif player2.checkmate?
      you_win(player1)
    else
      tie()
    end
  end

  def turn(player)
    while true
      starting_point = convert_to_coordinate(ask_starting_input())
      piece_to_move = @board.get_piece(starting_point)
      if piece_to_move == nil
        next
      end
      if piece_to_move.valid_moves.length < 1 || piece_to_move.valid_moves.all? {|move| player.simulate_move_for_check?(move, piece_to_move)}
        puts "this piece has no valid moves please select a different piece."
        @board.print_board
        next
      elsif piece_to_move && piece_to_move.team == player
        break
      else
        puts "Invalid input check if the postion you entered hold a piece on your team"
        @board.print_board
        next
      end
    end
    piece_to_move.valid_moves_check
    p piece_to_move.valid_moves
    while true
      destination = convert_to_coordinate(ask_ending_input())
      if piece_to_move.valid?(destination) && player.simulate_move_for_check?(destination, piece_to_move) == false
        piece_to_move.move(destination)
        break
      else
        puts "please enter a valid destination"
        @board.print_board
        next
      end
    end
    if player.colour == "black"
      @en_passant_black = nil
    elsif player.colour == "white"
      @en_passant_white = nil
    end
    @board.print_board
    @count50 += 1
    @count100 += 1
    @turn = player.opponent
    player.update_valid_moves
  end

  def ask_starting_input()
    while true
      puts 'Enter postion of piece you would like to move:'
      starting = gets.chomp().downcase
      if starting.length == 2 && starting[0].between?("a", "h") && starting[1].to_i.between?(1, 8)
          return starting
      end
    end
  end

  def ask_ending_input
    while true
      puts 'Enter where you would like to move the selected piece:'
      ending = gets.chomp().downcase
      if ending.length == 2 && ending[0].between?("a", "h") && ending[1].to_i.between?(1, 8)
        return ending
      end
    end
  end

  def convert_to_coordinate(string)
    conversion_map = {"a" => 1, "b" => 2, "c" => 3, "d" => 4, "e" => 5, "f" => 6, "g" => 7, "h" => 8}
    Position.new(conversion_map[string[0]], string[1].to_i)
  end

  def postion_to_alphanum(position)
    conversion_map = {1 => "a", 2 => "b", 3 => "c", 4 => "d", 5 => "e", 6 => "f", 7 => "g", 8 => "h"}
    "#{conversion_map[position.x] + position.y.to_s}"
  end

  def to_fen_string
    fen = ""
    (1..8).reverse_each do |y|
      space_count = 0
      for x in 1..8
        piece = @board.chess_board[[x, y]].piece
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
    fen += " #{@turn.colour[0]}"

      if @board.castle_rights(@player1) != "" && @player1.colour == "white"
        fen += " #{@board.castle_rights(@player1)}#{@board.castle_rights(@player2)}"
      elsif @board.castle_rights(@player1) != "" && @player2.colour == "white"
        fen += " #{@board.castle_rights(@player2)}#{@board.castle_rights(@player1)}"
      else
        fen += " -"
      end
      en_passant = @en_passant_black || @en_passant_white
      if en_passant
        fen += " #{postion_to_alphanum(en_passant)}"
      else
        fen += " -"
      end
    fen += " #{@count50} #{@count100}"
    fen
  end

  def you_win()
  end

  def statemate?()
    false
  end

  def tie
  end
end

game = Game.new()
game.start_game


=begin
board = ChessBoard.new 
player = Player.new('player1', 'black', 'top', board)
player2 = Player.new('player2', 'white', 'bottom', board, player)
player.opponent = player2
player.create_team
player2.create_team
board.print_board
p board.to_fen_string
=end
