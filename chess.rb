require_relative 'piece'
require_relative 'board'

class Chess
  def initialize
    @chess_board = Board.new
    @chess_board.generate
    @chess_board.add_pieces_to_board
    @player_turn = Board::W
  end

  def play_game
    take_turn until game_over?
  end

  def game_over?
    if check?
      if mate?
        true
      end
    elsif stalemate? || draw?
      true
    end
  end

##########################################
  # game_over? submethods
  def check?
    return false
    # get king position
    # king_position = scan_board
    # check king position against valid moves
  end

  def scan_board
    # row = 0
    # until row > 7
    #   col = 1
    #   until col > 8
    #     if @chess_board.board[row][col].class.to_s == "King" &&
    #        @chess_board.board[row][col].colour != @player_turn
    #       return [row, col]
    #     end
    #     col += 1
    #   end
    #   row += 1
    # end
  end

  def mate?
    false
  end

  def stalemate?
    false
  end

  def draw?
    false
  end
  # game_over? submethods
##########################################

  def take_turn
    clear_display
    welcome_message
    display_board
    player_input
    change_player
  end

##########################################
  # take_turn submethods
  def clear_display
    # system('clear') || system('clc')
  end

  def welcome_message
    # puts 'Welcome Chess!'
    # puts "Please use explicit syntax to move pieces.\n\n"
    # puts "You can save, load, or exit your game by typing 'save', 'load', or 'exit'"
    # puts "You can also propose a draw by entering 'draw'."
    # puts 'Good luck!'
  end

  def display_board
    @chess_board.display
  end

  def player_input
    valid = false
    until valid
        input
        if coordinates?
          if valid_move?
            update_board
            valid = true
          else
            valid = false
          end
        elsif command?
          execute_command
        else
          valid = false
        end
      end
  end

  def change_player
    @player_turn = @player_turn == Board::W ? Board::B : Board::W
  end
  # take_turn submethods
##########################################



##########################################
  # player_input submethods
  def input
    puts "It's #{@player_turn}'s turn. Please enter your move/ command."
    @input = gets.chomp.upcase
  end

  def coordinates?
    true if @input =~ /\A[a-h][1-8][a-h][1-8]\z/i
  end

  def valid_move?
    separate_coordinates
    return false if didnt_move?
    return false unless selected_piece_colour == @player_turn
    return false if destnation_colour == @player_turn
    return false unless legal_moves.include?(move)
    false if puts_in_check?
    return false if destnation_piece_type == "King"
    true
  end

  def update_board
    move_piece
    remove_piece
  end

  def move_piece
    @chess_board.board[@row_new][@col_new] = @chess_board.board[@row][@col]
  end

  def remove_piece
    @chess_board.board[@row][@col] = Piece.new(@chess_board.blank)
  end

  def command?
    command = ['EXIT','DRAW','LOAD','SAVE','CASTLE']
    true if command.include? @input
  end

  def execute_command
    case @input
    when 'EXIT'
      puts "Exiting game..."
      exit
    when 'DRAW'
      puts "It's a draw. Exiting game..."
      exit
    when 'CASTLE'
      puts 'Castling.'
      # castling function
    when 'SAVE'
      puts 'Game has been saved.'
      # save function
    when 'LOAD'
      puts 'Previous save has been loaded.'
      # load function
    end
  end
  # player_input submethods
##########################################


##########################################
  # valid_input? submethods
  def separate_coordinates
    piece = @input[0..1]
    @row = input_to_row(piece[1])
    @col = input_to_col(piece[0])

    location = @input[2..3]
    @row_new = input_to_row(location[1])
    @col_new = input_to_col(location[0])
  end

  def didnt_move?
    [@row, @col] == [@row_new, @col_new]
  end

  def selected_piece_colour
    @chess_board.board[@row][@col].colour
  end

  def selected_piece_type
    @chess_board.board[@row][@col].class.to_s
  end

  def destnation_colour
    @chess_board.board[@row_new][@col_new].colour
  end

  def legal_moves
     moves = possible_moves
     print "\n\npossible moves: #{moves}\n\n"
     print "\n\nmoves: #{coordinate_to_input(moves)}\n\n"
     moves
  end

  def possible_moves
    @chess_board.board[@row][@col].possible_moves(@row, @col,@chess_board.board)
  end

  def move
    [@row_new, @col_new]
  end

  def puts_in_check?
    false
  end

  def destnation_piece_type
    @chess_board.board[@row_new][@col_new].class.to_s
  end

  def input_to_row(row)
    8 - row.to_i
  end

  def input_to_col(col)
    case col
    when 'A'
      1
    when 'B'
      2
    when 'C'
      3
    when 'D'
      4
    when 'E'
      5
    when 'F'
      6
    when 'G'
      7
    when 'H'
      8
    end
  end
  # valid_input? submethods
##########################################
  def coordinate_to_input(moves)
    input_moves = []
    moves.each do |move|
      row = move[0]
      col = move[1]
      input_moves << col_to_input(col) + row_to_input(row).to_s
    end
    return input_moves
  end

  def row_to_input(row)
    (row - 8).abs
  end

  def col_to_input(col)
    case col
    when 1
      'A'
    when 2
      'B'
    when 3
      'C'
    when 4
      'D'
    when 5
      'E'
    when 6
      'F'
    when 7
      'G'
    when 8
      'H'
    end
  end
end

chess_game = Chess.new
chess_game.play_game
