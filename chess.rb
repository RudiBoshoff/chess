require_relative 'piece'
require_relative 'board'

class Chess
  def initialize
    @chess_board = Board.new
    @chess_board.generate
    @chess_board.add_pieces_to_board
    @player_turn = Board::W
    @white_in_check = false
    @black_in_check = false
  end

  def play_game
    take_turn until game_over?
  end

  def game_over?
    scan_for_check
    if check?
      scan_for_mate
      if mate?
        checkmate
        return true
      end
    elsif stalemate? || draw?
      return true
    end
    false
  end

  def take_turn
    clear_display
    welcome_message
    display_board
    player_in_check
    player_input
    change_player
  end

  def player_input
    valid = false
    until valid
      input
      if coordinates?
        puts "input: coordinates"
        if valid_move?
          puts "is a valid move"
          # Checkmate?
          puts "checkmate?"
          scan_for_mate
          break if mate?
          # In check already?
          puts "no"
          puts "in check already?"
          if @player_turn == Board::B && @black_in_check
            puts "yes"
            update_board
            scan_for_check
            # Still in check?
            puts "move piece"
            puts "still in check?"
            if @black_in_check
              puts "yes"
              backtrack_board
              scan_for_check
              puts "Invalid! You are still in check."
            else
              puts "not in check anymore"
              puts "move valid"
              valid = true
            end
          else
            puts "no"
            puts "board before"
            display_board
            update_board
            display_board
            puts "board after"
            scan_for_check
            puts "move piece"
            puts "in check now?"
            # Puts self in check?
            if @black_in_check
              puts "yes"
              backtrack_board
              puts "board after backtrack"
              display_board
              scan_for_check
              puts "Invalid! That will put you in check."
            else
              puts "no"
              puts "valid move"
              valid = true
            end
          end

        end
      elsif command?
        puts "input: command"
        execute_command
      else
        puts "input: invalid"
        valid = false
      end
    end
  end

  def checkmate
    clear_display
    welcome_message
    display_board
    change_player
    puts "Checkmate! #{@player_turn} is the Winner"
  end

  def check?
    if @white_in_check
      true
    elsif @black_in_check
      true
    else
      false
    end
  end

  def find_kings
    # looks for king locations
    row = 0
    while row <= 7
      col = 1
      while col <= 8
        if selected_piece_type(row, col) == 'King'
          if selected_piece_colour(row, col) == Board::W
            @white_king = [row, col]
          elsif selected_piece_colour(row, col) == Board::B
            @black_king = [row, col]
          end
        end
        col += 1
      end
      row += 1
    end
  end

  def scan_for_check
    # determine each pieces' moves
    scan_moves

    # locate the kings
    find_kings

    # white in check?
    white_in_check

    # black in check?
    black_in_check
  end

  def scan_moves
    @white_moves = []
    @black_moves = []

    r = 0
    while r <= 7
      c = 1
      while c <= 8
        if selected_piece_type(r, c) != 'Piece' && selected_piece_type(r, c) != 'King'
          if selected_piece_colour(r, c) == Board::B
            @black_moves << possible_moves(r, c)
          elsif selected_piece_colour(r, c) == Board::W
            @white_moves << possible_moves(r, c)
          end
        end
        c += 1
      end
      r += 1
    end
  end

  def white_in_check
    @white_in_check = false

    @black_moves.each do |moves|
      if moves.include?(@white_king)
        @white_in_check = true
      end
    end
  end

  def black_in_check
    @black_in_check = false

    @white_moves.each do |moves|
      if moves.include?(@black_king)
        @black_in_check = true
      end
    end
  end

  def compare_available_positions(king, moves)
    checkmate = []
    # Get king moves using King location
    king_moves = possible_moves(king[0], king[1])

    # Check if king moves are available
    king_moves.each do |move|
      list_of_moves = moves.flatten(1)
      checkmate << list_of_moves.include?(move)
    end

    # Is it checkmate?
    if checkmate.all? { |result| result == true }
      return true
    end
    false
  end

  def scan_for_mate
    if @white_in_check
      @checkmate = compare_available_positions(@white_king, @black_moves)
    elsif @black_in_check
      @checkmate = compare_available_positions(@black_king, @white_moves)
    end
  end

  def mate?
    return true if @checkmate
  end

  def stalemate?
    false
  end

  def draw?
    false
  end

  ##########################################
  # take_turn submethods
  def clear_display
    # system('clear') || system('clc')
  end

  def welcome_message
    puts 'Welcome to Chess!'
    puts 'Please use explicit syntax to move pieces.'
    puts "Typing A2A4 will move the piece at A2' to A4"
    puts "You can save, load, or exit your game by typing 'save', 'load', or 'exit'"
    puts "You can also propose a draw by entering 'draw'."
    puts 'Good luck!'
  end

  def display_board
    @chess_board.display
  end

  def player_in_check
    if @white_in_check
      puts "White in check!"
    elsif @black_in_check
      puts "Black in check!"
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
    puts "It's #{@player_turn.capitalize}'s turn. Please enter your move/ command."
    @input = gets.chomp.upcase
  end

  def coordinates?
    true if @input =~ /\A[a-h][1-8][a-h][1-8]\z/i
  end

  def valid_move?
    separate_coordinates

    return false if didnt_move?
    puts "moved?"
    puts "row : #{@row}, col : #{@col}"
    puts "player turn #{@player_turn}"
    puts "piece colour #{selected_piece_colour}"
    puts "piece colour #{selected_piece_type}"
    return false unless selected_piece_colour == @player_turn
    puts "selected correct colour"

    return false if destination_colour == @player_turn
    puts "destination colour is not the same"

    return false unless legal_moves.include?(move)
    puts "inside legal moves"

    return false if destination_piece_type == 'King'
    puts "destination not king"
    puts "passes everything"
    true
  end

  def update_board
    @backtrack_board = @chess_board
    @backtrack_board.board = @chess_board.board
    move_piece
    remove_piece
  end

  def backtrack_board
    @chess_board.board = @backtrack_board.board
    move_piece_back
    remove_test_piece
  end

  def move_piece_back
    @chess_board.board[@row][@col] = @chess_board.board[@row_new][@col_new]
  end

  def remove_test_piece
    @chess_board.board[@row_new][@col_new] = Piece.new(@chess_board.blank)
  end

  def move_piece
    @chess_board.board[@row_new][@col_new] = @chess_board.board[@row][@col]
  end

  def remove_piece
    @chess_board.board[@row][@col] = Piece.new(@chess_board.blank)
  end

  def command?
    command = %w[EXIT DRAW LOAD SAVE CASTLE]
    true if command.include? @input
  end

  def execute_command
    case @input
    when 'EXIT'
      puts 'Exiting game...'
      exit
    when 'DRAW'
      puts "It's a draw. Exiting game..."
      exit
    when 'CASTLE'
      puts 'Castling.'
      # castling function
      change_player
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

  def selected_piece_colour(row = @row, col = @col)
    @chess_board.board[row][col].colour
  end

  def selected_piece_type(row = @row, col = @col)
    @chess_board.board[row][col].class.to_s
  end

  def destination_colour
    @chess_board.board[@row_new][@col_new].colour
  end

  def legal_moves
    possible_moves
  end

  def possible_moves(row = @row, col = @col)
    @chess_board.board[row][col].possible_moves(row, col, @chess_board.board)
  end

  def move
    [@row_new, @col_new]
  end

  def destination_piece_type
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
end

chess_game = Chess.new
chess_game.play_game
