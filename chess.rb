require_relative 'piece'
require_relative 'board'

class Chess
  def initialize
    @chess_board = Board.new
    @chess_board.generate
    @chess_board.add_pieces_to_board
    @player_turn = Board::W
  end

  def user_input
    valid = false
    until valid
      selected_piece = select_piece
      puts selected_piece
      if valid_input?(selected_piece)
        piece_colour(selected_piece)
        piece_type
        select_location
        if valid_input?(select_location)
          valid = true
        end
      end
    end
  end

  def select_piece
    puts "It is #{@player_turn}'s turn. Select a chess piece"
    gets.chomp.upcase
  end

  def valid_input?(position)
    case position
    when 'EXIT'
      exit
    when 'DRAW'
      exit
    when 'CASTLE'
      puts 'castling'
      # castling function
      return true
    when 'SAVE'
      puts 'saving game'
      # save function
      return true
    when 'LOAD'
      puts 'loading game'
      # load function
      return true
    else
      return true if position =~ /\A[a-h][1-8]\z/i
    end
    false
  end

  def piece_colour(selected_piece)
    @current_pos = input_to_row_column(selected_piece[1], selected_piece[0])
    puts @current_pos
    @piece_colour = @chess_board.board[@current_pos[1]][@current_pos[0]].colour
  end

  def piece_type
    @piece_type = @chess_board.board[@current_pos[1]][@current_pos[0]].class.to_s
  end

  def select_location
    puts "#{@piece_type} selected. Place selected piece"
    gets.chomp.upcase
  end

  def move_piece
    new_pos = input_to_row_column(@location[1], @location[0])
    update_board(@current_pos, new_pos)
  end

  def input_to_row_column(row, col)
    row = 8 - row.to_i

    case col
    when 'A'
      col = 1
    when 'B'
      col = 2
    when 'C'
      col = 3
    when 'D'
      col = 4
    when 'E'
      col = 5
    when 'F'
      col = 6
    when 'G'
      col = 7
    when 'H'
      col = 8
    end

    [row, col]
  end

  def update_board(current_position, new_position)
    row = new_position.first
    col = new_position.last

    old_row = current_position.first
    old_col = current_position.last

    @chess_board.board[row][col] = @chess_board.board[old_row][old_col]

    @chess_board.board[old_row][old_col] = Piece.new(@chess_board.blank)
  end

  def welcome_message; end

  def clear_display
    system('clear') || system('clc')
  end

  def display_board
    @chess_board.display
  end

  def change_player
    @player_turn = @player_turn == Board::W ? Board::B : Board::W
  end

  def game
    clear_display
    welcome_message
    display_board
    loop do
      user_input
      move_piece
      change_player
      clear_display
      display_board
    end
  end
end

chess_game = Chess.new
chess_game.game
