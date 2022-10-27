require_relative '../lib/game.rb'

describe ChessBoard do 
  describe '#start_game' do
    subject(:game) { Game.new() }
    before do
      game.start_game
      allow(game).to receive(:gets) 
  end
end