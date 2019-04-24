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
    if check?
      if mate?
        puts 'checkmate'
        return true
      end
    elsif stalemate? || draw?
      true
    end
  end

  ##########################################
  # game_over? submethods
  def check?
    if @white_in_check || @black_in_check
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
        puts "#{selected_piece_colour(@white_king[0], @white_king[1]).capitalize} is in check!"
      end
    end
  end

  def black_in_check
    @black_in_check = false

    @white_moves.each do |moves|
      if moves.include?(@black_king)
        @black_in_check = true
        puts "#{selected_piece_colour(@black_king[0], @black_king[1]).capitalize} is in check!"
      end
    end
  end

  def scan_for_mate
    if @white_in_check
      checkmate = []
      king_moves = possible_moves(@white_king[0], @white_king[1])

      king_moves.each do |move|
        list_of_moves = @black_moves.flatten(1)
          checkmate << if list_of_moves.include?(move)
                         true
                       else
                         false
                       end
      end

      if checkmate.all? { |result| result == true }
        puts 'Checkmate! Black is the winner.'
        @checkmate = true
        return true
      end
    elsif @black_in_check
      checkmate = []
      king_moves = possible_moves(@black_king[0], @black_king[1])

      king_moves.each do |move|
        list_of_moves = @white_moves.flatten(1)
          checkmate << if list_of_moves.include?(move)
                         true
                       else
                         false
                       end
      end

      if checkmate.all? { |result| result == true }
        puts 'Checkmate! White is the winner.'
        @checkmate = true
        return true
      end
    else
      false
    end
  end

  def mate?
    @checkmate
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
    scan_for_mate
    exit if @checkmate
    scan_for_check
    player_input
    change_player
  end

  ##########################################
  # take_turn submethods
  def clear_display
    system('clear') || system('clc')
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

  def player_in_check?
    if @player_turn == Board::W && @white_in_check
      true
    elsif @player_turn == Board::B && @black_in_check
      true
    else
      false
    end
  end

  def player_input
    valid = false
    until valid
      input
      if coordinates?
        if valid_move?
          if player_in_check?
            unless scan_for_mate
              update_board
              scan_for_check
                if player_in_check?
                  backtrack_board
                  valid = false
                else
                  valid = true
                end
            end
          else
            update_board
            scan_for_check
            if player_in_check?
              puts "That will put you in check!"
              backtrack_board
              valid = false
            else
              valid = true
            end
          end
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
    @backtrack_board = @chess_board.board
    move_piece
    remove_piece
  end

  def backtrack_board
    @chess_board.board = @backtrack_board
  end

  def move_piece
    @old_piece = @chess_board.board[@row_new][@col_new]
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
