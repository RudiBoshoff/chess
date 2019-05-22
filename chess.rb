# frozen_string_literal: true

# Rudi Boshoff
require 'yaml'
require_relative 'piece'
require_relative 'board'

class Chess
  def initialize
    @chess_board = Board.new
    @chess_board.generate_board
    @chess_board.add_pieces_to_board
    @player_turn = Board::W
    @white_in_check = false
    @black_in_check = false
  end

  def save_game
    save = File.new('save.yml', 'w+')
    data = { board: @chess_board,
             turn: @player_turn,
             w_check: @white_in_check,
             b_check: @black_in_check }
    save.puts YAML.dump(data)
    save.close
  end

  def load_game
    if File.exist?('save.yml')
      save = File.new('save.yml', 'r+')
      data = YAML.safe_load(save.read)
      @chess_board = data[:board]
      @player_turn = data[:turn]
      @white_in_check = data[:w_check]
      @black_in_check = data[:b_check]
      save.close
      reset_board
      puts "Previous save has been loaded.\n\n"
    else
      puts 'No save file detected!'
    end
  end

  def play_game
    take_turn until game_over?
  end

  ##########################################
  # play_game submethods
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
    reset_board
    display_player_status
    player_input
    change_player
  end
  # play_game submethods
  ##########################################

  ##########################################
  # game_over? submethods
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

  def check?
    if @white_in_check
      true
    elsif @black_in_check
      true
    else
      false
    end
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

  def checkmate
    reset_board
    change_player
    puts "Checkmate! #{@player_turn.capitalize} is the Winner"
  end

  def stalemate?
    false
  end

  def draw?
    false
  end
  # game_over? submethods
  ##########################################

  ##########################################
  # take_turn submthods
  def clear_display
    system('clear') || system('clc')
  end

  def welcome_message
    puts 'Welcome to Chess!'
    puts 'Please use explicit syntax to move pieces.'
    puts "Typing 'A2A4' will move the piece at 'A2' to 'A4'"
    puts 'You can save, load, or exit your game by typing:'
    puts "'save', 'load', or 'exit'"
    puts "You can also propose a draw by entering 'draw'."
    puts 'Good luck!'
  end

  def display_board
    @chess_board.display
  end

  def display_player_status
    if @white_in_check
      puts 'White in check!'
    elsif @black_in_check
      puts 'Black in check!'
    end
  end

  def player_input
    valid = false
    until valid
      input
      if coordinates?
        if valid_move?
          # Checkmate?
          scan_for_mate
          break if mate?

          # In check already?
          if @player_turn == Board::B && @black_in_check
            update_board
            scan_for_check

            # Still in check?
            if @black_in_check
              still_in_check
            else
              valid = true
            end

          # In check already?
          elsif @player_turn == Board::W && @white_in_check
            update_board
            scan_for_check

            # Still in check?
            if @white_in_check
              still_in_check
            else
              valid = true
            end
          else
            update_board
            scan_for_check

            # Puts self in check?
            if @black_in_check && @player_turn == Board::B
              puts_self_in_check
            elsif @white_in_check && @player_turn == Board::W
              puts_self_in_check
            else
              valid = true
            end
          end
        end
      elsif command?
        execute_command
      else
        display_invalid_message
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
  # player_input submthods
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
    return false unless selected_piece_colour == @player_turn
    return false if destination_colour == @player_turn
    return false unless legal_moves.include?(move)
    return false if destination_piece_type == 'King'

    true
  end

  def update_board
    @backtrack_board = @chess_board
    @backtrack_board.board = @chess_board.board
    move_piece
    remove_piece
  end

  def still_in_check
    backtrack_board
    scan_for_check
    puts 'Invalid move! You are still in check.'
  end

  def puts_self_in_check
    backtrack_board
    scan_for_check
    puts 'Invalid move! That will put you in check.'
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
      castle
    when 'SAVE'
      puts 'Game has been saved.'
      save_game
      puts 'Exiting game...'
      exit
    when 'LOAD'
      load_game
      display_player_status
    end
  end

  def castle
    if @player_turn == Board::W && @white_in_check
      puts 'Cannot castle while in check!'
    elsif @player_turn == Board::B && @black_in_check
      puts 'Cannot castle while in check!'
    else
      row = @player_turn == Board::B ? 0 : 7

      @long_castle = false
      @short_castle = false

      castle_king(row) if castling_valid?(row)

      if @long_castle == false && @short_castle == false
        puts 'Castling invalid'
      else
        change_player
      end
    end
  end

  def castling_valid?(row)
    @long_castle = long_castle?(row)
    @short_castle = short_castle?(row)
    return true if @long_castle || @short_castle

    false
  end

  def long_castle?(row)
    if selected_piece_type(row, 1) == 'Rook' &&
       selected_piece_type(row, 2) == 'Piece' &&
       selected_piece_type(row, 3) == 'Piece' &&
       selected_piece_type(row, 4) == 'Piece' &&
       selected_piece_type(row, 5) == 'King'
      return true if selected_piece_colour(row, 1) == @player_turn &&
                     selected_piece_colour(row, 5) == @player_turn
    end
    false
  end

  def short_castle?(row)
    if selected_piece_type(row, 8) == 'Rook' &&
       selected_piece_type(row, 7) == 'Piece' &&
       selected_piece_type(row, 6) == 'Piece' &&
       selected_piece_type(row, 5) == 'King'
      return true if selected_piece_colour(row, 8) == @player_turn &&
                     selected_piece_colour(row, 5) == @player_turn
    end
    false
  end

  def castle_pieces(row)
    @backtrack_board.board = @chess_board.board
    if @long_castle
      move_piece(row, 4, row, 1)
      move_piece(row, 3, row, 5)
      remove_piece(row, 1)
      remove_piece(row, 5)
    else
      move_piece(row, 6, row, 8)
      move_piece(row, 7, row, 5)
      remove_piece(row, 8)
      remove_piece(row, 5)
    end
  end

  def undo_castling(row)
    @chess_board.board = @backtrack_board.board
    if @long_castle
      move_piece(row, 1, row, 4)
      move_piece(row, 5, row, 3)
      remove_piece(row, 4)
      remove_piece(row, 3)
    else
      move_piece(row, 8, row, 6)
      move_piece(row, 5, row, 7)
      remove_piece(row, 6)
      remove_piece(row, 7)
    end
    puts "That will put you in check!"
  end

  def castle_king(row)
    castle_pieces(row)
    scan_for_check
    if @black_in_check && @player_turn == Board::B
      undo_castling(row)
    end
    if @white_in_check && @player_turn == Board::W
      undo_castling(row)
    end
    puts @row
    puts @col
    player_input
    puts @row
    puts @col
  end

  def reset_board
    clear_display
    welcome_message
    display_board
  end

  def display_invalid_message
    puts 'Input invalid. Please enter coordinates or a command.'
    puts "coordinates: \teg. 'a2a4'"
    puts "command: \teg. 'exit'"
  end
  # player_input submthods
  ##########################################

  ##########################################
  # valid_move? submethods
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

  def destination_colour
    @chess_board.board[@row_new][@col_new].colour
  end

  def legal_moves
    possible_moves
  end

  def move
    [@row_new, @col_new]
  end

  def destination_piece_type
    @chess_board.board[@row_new][@col_new].class.to_s
  end
  # valid_move? submethods
  ##########################################

  ##########################################
  # separate_coordinates submethods
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
  # separate_coordinates submethods
  ##########################################

  ##########################################
  # scan_for_check submethods
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

  def white_in_check
    @white_in_check = false

    @black_moves.each do |moves|
      @white_in_check = true if moves.include?(@white_king)
    end
  end

  def black_in_check
    @black_in_check = false

    @white_moves.each do |moves|
      @black_in_check = true if moves.include?(@black_king)
    end
  end
  # scan_for_check submethods
  ##########################################

  ##########################################
  # update_board submethods
  def move_piece(row_new = @row_new, col_new = @col_new, row = @row, col = @col)
    @chess_board.board[row_new][col_new] = @chess_board.board[row][col]
  end

  def remove_piece(row = @row, col = @col)
    @chess_board.board[row][col] = Piece.new(@chess_board.empty_block)
  end
  # update_board submethods
  ##########################################

  ##########################################
  # still_in_check and puts_self_in_check submethods
  def backtrack_board
    @chess_board.board = @backtrack_board.board
    move_piece_back
    remove_test_piece
  end
  # still_in_check and puts_self_in_check submethods
  ##########################################

  ##########################################
  # backtrack_board submethods
  def move_piece_back
    @chess_board.board[@row][@col] = @chess_board.board[@row_new][@col_new]
  end

  def remove_test_piece
    @chess_board.board[@row_new][@col_new] = Piece.new(@chess_board.empty_block)
  end
  # backtrack_board submethods
  ##########################################

  ##########################################
  # scan_for_mate submethods
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
    return true if checkmate.all? { |result| result == true }

    false
  end
  # scan_for_mate submethods
  ##########################################

  ##########################################
  # scan_moves submethods
  def selected_piece_type(row = @row, col = @col)
    @chess_board.board[row][col].class.to_s
  end

  def possible_moves(row = @row, col = @col)
    @chess_board.board[row][col].possible_moves(row, col, @chess_board.board)
  end
  # scan_moves submethods
  ##########################################
end

chess_game = Chess.new
chess_game.play_game
