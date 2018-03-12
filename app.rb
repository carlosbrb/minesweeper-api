require 'cuba'
require 'cuba/safe'
require 'mongoid'
require_relative 'models/game'
Mongoid.load!('config/mongoid.yml', :development)

Cuba.use Rack::Session::Cookie, secret: 'ItVkZphTrBUkiRkh3ajLf9NQePwoxLPJGCExzBu1EY0r82G3TrzTSvmvFF1e'

Cuba.plugin Cuba::Safe

Cuba.define do
  res.headers['Content-Type'] = 'application/json'
  on get do
    on 'games' do
      res.write JSON.dump(Game.all.map(&:id))
    end

    on 'game/:id' do |id|
      game = Game.find(id)
      res.write JSON.dump(game.board)
    end

    on root do
      res.redirect '/games'
    end
  end

  on post do
    on 'game', param('rows'), param('cols'), param('mines') do |rows, cols, mines|
      game = Game.create(state: 'new',
                         mines: mines,
                         cols: cols,
                         rows: rows)
      res.write game.to_json
    end

    on 'game/:id/flag', param('row'), param('col') do |id, row, col|
      game = Game.find(id)
      game.flag(row.to_i, col.to_i)
      res.write game.to_json
    end
  end
end
