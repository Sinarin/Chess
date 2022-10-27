require_relative '../lib/game.rb'

describe ChessBoard do 
  describe '#start_game' do
    subject(:game) { Game.new() }
    before do
      allow(game).to receive(:gets).and_return('')
      allow(game).to receive(:gets).and_return('b8', 'a6', '', 'b1', 'a3' , 'a6', 'b8' 'n', 'a3', 'b1').times(5)
    end
    it 'returns true' do
      expect(game).to receive(:tie)
      game.start_game
    end
  end
end