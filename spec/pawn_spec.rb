require_relative '../lib/pawn'
require_relative '../lib/vector'
require_relative '../lib/player'
require_relative '../lib/board'

describe Pawn do
  describe '#valid_moves' do
    subject(:board)  {ChessBoard.new()}
    let(:player1) { instance_double(Player, colour: "black", side: "bottom") }
    let(:player2) { instance_double(Player, colour: "white", side: "top") }
    subject(:pawn) { described_class.new(board, Position.new(2, 2), player1) }

    it 'moves forward' do
      pawn.move(Position.new(2, 3))
      expect(board.get_piece(Position.new(2, 3))).to eq pawn
    end

    it "can't en passant unless given the move" do
      
  end

end