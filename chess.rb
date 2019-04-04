require_relative 'piece'
require_relative 'board'

class Chess
  def initialize
    @board = Board.new
    @board.generate
    @board.add_pieces_to_board
  end

  def move_piece
    input = gets.chomp
  end

  def valid_input?(input)

  end

  def welcome_message

  end

  def clear_display

  end

  def display_board
    @board.display
  end

  def game
    welcome_message
    display_board
  end
end

chess_game = Chess.new
