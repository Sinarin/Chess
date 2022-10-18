
describe ChessBoard do
  describe '#castle_rights' do
    it 'returns KQ' do
      subject(:board)  {ChessBoard.new()}
      let(:player1) { instance_double(Player, colour: "black", side: "bottom") }
      let(:player2) { instance_double(Player, colour: "white", side: "top") }
    end
  end
end