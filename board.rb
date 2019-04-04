require_relative 'piece'

class Board
  attr_accessor :board

  def initialize
    @w_pawn = "\u265F"
    @w_rook = "\u265C"
    @w_knight = "\u265E"
    @w_bishop = "\u265D"
    @w_queen = "\u265B"
    @w_king = "\u265A"

    @b_pawn = "\u2659"
    @b_rook = "\u2656"
    @b_knight = "\u2658"
    @b_bishop = "\u2657"
    @b_queen = "\u2655"
    @b_king = "\u2654"

    @blank = "\u26F6 "
  end

  def generate
    # Creates board filled with blanks
    @board = Array.new(8) { Array.new(9, @blank.force_encoding('utf-8')) }

    # Creates labels for board
    num = 0
    (@board.size - 1).downto 0 do |index|
      num += 1
      @board[index][0] = (num).to_s + '  '
    end
  end

  def display
    width = @board.flatten.max.to_s.size
    puts @board.map { |a| a.map(&:to_s).join }
    puts "\n"
    labels = %w[A B C D E F G H]
    labels.unshift ' '
    puts labels.map { |i| i.to_s.rjust(width) }.join
  end

  def add_pieces_to_board

  end
end
board = Board.new
board.generate
board.display
