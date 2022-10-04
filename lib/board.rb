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

  def print_board
  end


end


class Square
  attr_reader :value 
  attr_accessor :adjacent_nodes
  def initialize(value = nil)
    @value = value
    @adjacent_nodes = []
    @piece = nil
  end

  def add_edge(node)
    @adjacent_nodes << node
  end
end

board = ChessBoard.new  
print board.chess_board