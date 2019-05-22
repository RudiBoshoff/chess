# Rudi Boshoff
require_relative 'piece'

class Board
  attr_accessor :board, :empty_block

  B = 'black'.freeze
  W = 'white'.freeze

  def initialize
    assign_utfs_to_pieces
  end

  def assign_utfs_to_pieces
    assign_white_utfs
    assign_black_utfs
    assign_empty_block_utf
  end

  def generate_board
    # Creates board, a 2D Array, filled with blanks
    generate_empty_board
    add_labels_to_board
  end

  def add_pieces_to_board
    add_pawns
    add_rooks
    add_knights
    add_bishops
    add_kings
    add_queens
  end

  def display
    display_board_with_pieces
    display_labels
  end


  ##########################################
  # assign_utfs_to_pieces submethods
  def assign_white_utfs
    @w_pawn = "\u265F "
    @w_rook = "\u265C "
    @w_knight = "\u265E "
    @w_bishop = "\u265D "
    @w_queen = "\u265B "
    @w_king = "\u265A "
  end

  def assign_black_utfs
    @b_pawn = "\u2659 "
    @b_rook = "\u2656 "
    @b_knight = "\u2658 "
    @b_bishop = "\u2657 "
    @b_queen = "\u2655 "
    @b_king = "\u2654 "
  end

  def assign_empty_block_utf
    @empty_block = "\u26F6 "
  end
  # assign_utfs_to_pieces submethods
  ##########################################


  ##########################################
  # generate_board submethods
  def generate_empty_board
    @board = Array.new(8) { Array.new(9, Piece.new(@empty_block)) }
  end

  def add_labels_to_board
    @board.each_with_index do |_, index|
      @board[index][0] = Piece.new('   ' + (@board.size - index).to_s + '  ')
    end
  end
  # generate_board submethods
  ##########################################


  ##########################################
  # add_pieces_to_board submethods
  def add_pawns
    col = 1
    while col <= 8
    # @board[1][col] = Pawn.new(@b_pawn, B)
    # @board[6][col] = Pawn.new(@w_pawn, W)

      # TESTING BOARD
      @board[1][5] = Pawn.new(@b_pawn, B)
      @board[1][6] = Pawn.new(@b_pawn, B)
      @board[1][7] = Pawn.new(@b_pawn, B)
      @board[6][col] = Rook.new(@w_rook, W)
      @board[6][4] = Pawn.new(@w_pawn, W)
      @board[6][6] = Pawn.new(@w_pawn, W)
      @board[6][7] = Pawn.new(@w_pawn, W)

      col += 1
    end
  end

  def add_rooks
    @board[0][1] = Rook.new(@b_rook, B)
    @board[0][8] = Rook.new(@b_rook, B)
    @board[7][1] = Rook.new(@w_rook, W)
    @board[7][8] = Rook.new(@w_rook, W)
  end

  def add_knights
    # @board[0][2] = Knight.new(@b_knight, B)
    # @board[0][7] = Knight.new(@b_knight, B)
    @board[7][2] = Knight.new(@w_knight, W)
    @board[7][7] = Knight.new(@w_knight, W)
  end

  def add_bishops
    # @board[0][3] = Bishop.new(@b_bishop, B)
    # @board[0][6] = Bishop.new(@b_bishop, B)
    @board[7][3] = Bishop.new(@w_bishop, W)
    @board[7][6] = Bishop.new(@w_bishop, W)
  end

  def add_kings
    @board[0][5] = King.new(@b_king, B)
    @board[7][5] = King.new(@w_king, W)
  end

  def add_queens
    # @board[0][4] = Queen.new(@b_queen, B)
    @board[7][4] = Queen.new(@w_queen, W)
  end
  # add_pieces_to_board submethods
  ##########################################


  ##########################################
  # display submethods
  def display_board_with_pieces
    puts "\n"
    puts @board.map { |array| array.map(&:appearance).join }
    puts "\n"
  end

  def display_labels
    labels = %w[A B C D E F G H]
    labels.unshift '     '
    puts labels.map { |i| i.to_s.rjust(2) }.join
    puts "\n"
  end
  # display submethods
  ##########################################
end
