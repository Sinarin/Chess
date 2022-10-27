
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
    @board_state = Hash.new(0)
  end

  def ask_save
    puts "would you like to save your game?"
    answer = gets.chomp.downcase
    if answer == "y" || answer == "yes"
      save()
    end
  end

  def name_file
    while true
      puts "What would you like to name your file? (letters, numbers and underscores only)"
      filename = gets.chomp
      if filename !~ /\A[a-zA-z0-9_]+\z/
        puts "Invalid file name. Try Again."
      elsif File.exist?('save_files/' + filename + ".dat")
        puts "File name exists already, do you want to write over this file?"
        answer = gets.chomp.downcase
        if answer == "y" || answer == "yes"
          break
        end
      end
    end
    filename ='save_files/' + filename + ".dat"
    return filename
  end

  def save
    filename = name_file
    Dir.mkdir('save_files') unless Dir.exist?('save_files')
    File.open(filename, "w") do |file|
      file.write Marshal.dump(self)
    end
  end

  def load
    puts "enter file name (without file extension)"
    filename = 'save_files/' + gets.chomp + '.dat'
    if File.exist?(filename)
      file = File.open(filename, 'r').read
      d = Marshal.load(file)
    else
      puts "filename does not exist, please enter a valid text save file."
      load()
    end
    d
  end

  def start_game
    puts "would like like to load a past game file?"
    answer = gets.chomp.downcase
    if answer == "y" || answer == "yes"
      load.start_turns
    else
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
      start_turns()
    end
  end

  def add_fen()
    fen = to_fen_string
    @board_state[fen[0, fen.length - 4]] += 1
  end

  def start_turns
    p to_fen_string
    p @board.castle_rights(@player1)
    while 
      #add counter in here to count for stalemate
      turn(@turn)
      @turn.update_valid_moves
      break if @turn.checkmate? || stalemate?()
      p @board_state
      
      ask_save()
      turn(@turn)
      @turn.update_valid_moves
      break if @turn.checkmate? || stalemate?()
      p @board_state
    end

    if @turn.checkmate?
      you_win(@turn.opponent)
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

  def you_win(player)
    puts "#{player.opponent.name} has been checkmated, #{player.name} Wins!"
    puts "would you like to play again?"
    answer = gets.chomp.downcase
    if answer == "y" || answer == "yes"
      start_game()
    else
      exit
    end
  end

  def stalemate?()
    add_fen() == 3 || insufficent_pieces() || @count50 == 50
  end

  def insufficent_pieces()
  end

  def tie
    puts "Draw"
    puts "would you like to play again?"
    answer = gets.chomp.downcase
    if answer == "y" || answer == "yes"
      start_game()
    else
      exit
    end
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
