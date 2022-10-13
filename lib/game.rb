
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

def start_game
  board = ChessBoard.new 
  player = Player.new('player1', 'black', 'top', board)
  player2 = Player.new('player2', 'white', 'bottom', board, player)
  player.opponent = player2
  player.create_team
  player2.create_team
  board.print_board

  while 
    #add counter in here to count for statemate
    turn(player1)
    break if player2.checkmate? || statemate?()
    turn(player2)
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

def turn()
end

def you_win()
end

def statemate?()
end

def tie
end
