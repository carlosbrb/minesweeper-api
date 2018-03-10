class Game
  include Mongoid::Document
  field :user_id, type: Integer
  field :time, type: Time
  field :rows, type: Integer
  field :cols, type: Integer
  field :board, type: Array
  field :state, type: String
  field :mines, type: Integer

  UNDISCOVERED = ' '.freeze
  MINE  = '*'.freeze
  FLAG  = 'B'.freeze
  SAFE  = '^'.freeze
  DISCOVERED = '_'.freeze

  before_save :create_board

  def create_board
    self.board = Array.new(cols).map { Array.new(rows).map { UNDISCOVERED } }
  end

end
