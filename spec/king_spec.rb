require_relative '../lib/king'
require_relative '../lib/vector'
require_relative '../lib/player'
require_relative '../lib/board'


describe ChessBoard do
  describe '#castle_rights' do
    subject(:board)  {ChessBoard.new()}
    let(:king) { instance_double(King, castling_vector: [Vector.new(-2, 0), Vector.new(2, 0)], current_position: Position.new(5, 8))}
    let(:player1) { instance_double(Player, colour: "black", side: "bottom", king: king) }
    let(:player2) { instance_double(Player, colour: "white", side: "top") }

    before do
      allow(king).to receive_message_chain(:valid_moves, :any?).and_return(true)
    end

    it 'returns kq' do
      expect(board.castle_rights(player1)).to eq "kq"
    end
  end
end