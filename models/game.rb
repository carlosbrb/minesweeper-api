class Game
  include Mongoid::Document
  field :user_id, type: Integer
  field :time, type: Time
  field :rows, type: Integer
  field :cols, type: Integer
  field :board, type: Array
  field :state, type: String
  field :mines, type: Integer
  field :mine_places, type: Array

  UNDISCOVERED = '#'.freeze
  MINE_MARK = '*'.freeze
  FLAG_MARK = 'F'.freeze
  QUESTION_MARK = '?'.freeze
  SAFE_MARK = '^'.freeze
  DISCOVERED = 'D'.freeze

  before_create :create_board, :put_mines

  def create_board
    self.board = Array.new(cols).map { Array.new(rows).map { UNDISCOVERED } }
    self.mine_places = Array.new(cols).map { Array.new(rows).map { ' ' } }
  end

  def put_mines
    while mine_counter < mines
      prow = rand(rows)
      pcol = rand(cols)
      mine_places[pcol][prow] = MINE_MARK
    end
  end

  def mine_counter
    counter = 0
    mine_places.each do |row|
      row.each do |cell|
        counter += 1 if cell == MINE_MARK
      end
    end
    counter
  end

  def flag(row, col)
    if board[row][col] == UNDISCOVERED
      board[row][col] = FLAG_MARK
    elsif board[row][col] == FLAG_MARK
      board[row][col] = QUESTION_MARK
    else
      board[row][col] = UNDISCOVERED
    end
    save
  end

  def as_json(*)
    {
      "id": id.to_s,
      "board": board,
      "state": state,
      "mines": mines
    }
  end

end
