require_relative 'piece'

class Board
  attr_accessor :board

  def initialize
    @w_pawn = "\u265F "
    @w_rook = "\u265C "
    @w_knight = "\u265E "
    @w_bishop = "\u265D "
    @w_queen = "\u265B "
    @w_king = "\u265A "

    @b_pawn = "\u2659 "
    @b_rook = "\u2656 "
    @b_knight = "\u2658 "
    @b_bishop = "\u2657 "
    @b_queen = "\u2655 "
    @b_king = "\u2654 "

    # @blank = "\u26F6 "  empty square

    @blank = " \u00b7"
  end

  def generate
    # Creates board filled with blanks
    @board = Array.new(8) { Array.new(9, @blank.force_encoding('utf-8')) }

    # Creates labels for board
    @board.each_with_index do |_, index|
      @board[index][0] = (@board.size - index).to_s + '  '
    end
  end

  def display
    width = @board.flatten.max.to_s.size
    puts "\n"
    puts @board.map { |a| a.map(&:to_s).join }
    puts "\n"
    labels = %w[A B C D E F G H]
    labels.unshift ' '
    puts labels.map { |i| i.to_s.rjust(width) }.join
  end

  def add_pieces_to_board
    # Adds pawns to board

    row = 1
    while row < 9
      @board[1][row] = @b_pawn
      @board[6][row] = @w_pawn
      row += 1
    end



    # Adds rooks to board
    @board[0][1] = @b_rook
    @board[0][8] = @b_rook
    @board[7][1] = @w_rook
    @board[7][8] = @w_rook

    # Adds knights to board
    @board[0][2] = @b_knight
    @board[0][7] = @b_knight
    @board[7][2] = @w_knight
    @board[7][7] = @w_knight

    # Adds bishops to board
    @board[0][3] = @b_bishop
    @board[0][6] = @b_bishop
    @board[7][3] = @w_bishop
    @board[7][6] = @w_bishop

    # Adds kings to baord
    @board[0][5] = @b_king
    @board[7][5] = @w_king

    # Adds queens to board
    @board[0][4] = @b_queen
    @board[7][4] = @w_queen
  end
end
board = Board.new
board.generate
board.add_pieces_to_board
board.display
