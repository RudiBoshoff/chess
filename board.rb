require_relative 'piece'

class Board
  attr_accessor :board, :blank, :log

  B = 'black'.freeze
  W = 'white'.freeze

  def initialize
    # Assigns utf8 codes for each type of piece
    # white
    @w_pawn = "\u265F "
    @w_rook = "\u265C "
    @w_knight = "\u265E "
    @w_bishop = "\u265D "
    @w_queen = "\u265B "
    @w_king = "\u265A "

    # black
    @b_pawn = "\u2659 "
    @b_rook = "\u2656 "
    @b_knight = "\u2658 "
    @b_bishop = "\u2657 "
    @b_queen = "\u2655 "
    @b_king = "\u2654 "

    # empty block
    @blank = "\u26F6 "
    # @blank = " \u00b7"

    # list of moves
    @log = ""
  end

  def generate
    # Creates board, a 2D Array, filled with blanks
    @board = Array.new(8) { Array.new(9, Piece.new(@blank)) }

    # Creates labels for board
    @board.each_with_index do |_, index|
      @board[index][0] = Piece.new('   ' + (@board.size - index).to_s + '  ')
    end
  end

  def display
    # Displays board with pieces
    puts "\n"
    puts @board.map { |array| array.map{|piece| piece.appearance}.join}
    puts "\n"

    # Displays labels
    labels = %w[A B C D E F G H]
    labels.unshift '     '
    puts labels.map { |i| i.to_s.rjust(2) }.join
    puts "\n"
  end

  def add_pieces_to_board
    # Adds pawns to board
    col = 1
    while col <= 8
      @board[1][col] = Pawn.new(@b_pawn, B)
      @board[6][col] = Pawn.new(@w_pawn, W)
      col += 1
    end

    # Adds rooks to board
    @board[0][1] = Rook.new(@b_rook, B)
    @board[0][8] = Rook.new(@b_rook, B)
    @board[7][1] = Rook.new(@w_rook, W)
    @board[7][8] = Rook.new(@w_rook, W)

    # Adds knights to board
    @board[0][2] = Knight.new(@b_knight, B)
    @board[0][7] = Knight.new(@b_knight, B)
    @board[7][2] = Knight.new(@w_knight, W)
    @board[7][7] = Knight.new(@w_knight, W)

    # Adds bishops to board
    @board[0][3] = Bishop.new(@b_bishop, B)
    @board[0][6] = Bishop.new(@b_bishop, B)
    @board[7][3] = Bishop.new(@w_bishop, W)
    @board[7][6] = Bishop.new(@w_bishop, W)

    # Adds kings to baord
    @board[0][5] = King.new(@b_king, B)
    @board[7][5] = King.new(@w_king, W)

    # Adds queens to board
    @board[0][4] = Queen.new(@b_queen, B)
    @board[7][4] = Queen.new(@w_queen, W)
  end
end
