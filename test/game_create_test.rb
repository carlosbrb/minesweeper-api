require 'cuba/test'
require_relative '../app'

scope do
  test 'Create new game' do
    post '/game/2/2/2' do
      assert_equal [[" ", " "], [" ", " "]], JSON.parse(last_response.body)['board']
    end
  end
end
