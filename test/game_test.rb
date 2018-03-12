require 'cuba/test'
require_relative '../app'
Mongoid.load!('config/mongoid.yml', :test)

scope do
  test 'return error message when missed params' do
    post '/game' do
      assert_equal 404, last_response.status
    end
  end

  test 'create a new game with right parameters' do
    post '/game?cols=2&rows=2&mines=1' do
      assert_equal [['#', '#'], ['#', '#']], JSON.parse(last_response.body)['board']
    end
  end

  test 'it flags a game cell' do
    game = Game.create(state: 'new',
                       mines: 2,
                       cols: 4,
                       rows: 4)
    post "/game/#{game.id.to_s}/flag?row=1&col=1" do
      assert_equal 'F', JSON.parse(last_response.body)['board'][1][1]
    end
  end
end
