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
      # user input should get "e3" move format or a command eg. "exit"
      select_piece
      input = gets.chomp.upcase
      @log1 = input

      # check for coordinates eg. "e3"
      if valid_input?(input)
        row = input_to_row(input[1])
        col = input_to_column(input[0])

        # check if piece is same colour as player
        piece_colour(row, col)
        if @piece_colour == @player_turn
          # determine piece type: used later(king next to king)
          piece_type(row, col)
          # select new location for piece
          select_location
          location = gets.chomp.upcase
          @log2 = location

          # check for new coordinates eg. "e3"
          if valid_input?(location)
            row_new = input_to_row(location[1])
            col_new = input_to_column(location[0])

            # check if new coordinates = old coordinates
            if row_new == row && col_new == col
              valid = false
              puts 'You cant enter the same location'
            else
              # passes all tests so moves piece
              valid = true
              update_board(row, col, row_new, col_new)
              log_move
            end
          end

        # piece is not same colour as player
        else
          puts 'You must move your own piece'
        end

      # check for command
      elsif check_for_command(input)
        valid = true

      # input is invalid
      else
        puts 'Invalid input'
      end
    end
  end

  def select_piece
    puts "It is #{@player_turn}'s turn. Select a chess piece or enter a command"
  end

  def valid_input?(position)
    true if position =~ /\A[a-h][1-8]\z/i
  end

  def input_to_row(row)
    8 - row.to_i
  end

  def input_to_column(col)
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

  def piece_colour(row, col)
    @piece_colour = @chess_board.board[row][col].colour
  end

  def piece_type(row, col)
    @piece_type = @chess_board.board[row][col].class.to_s
  end

  def select_location
    puts "#{@piece_type} selected. Place selected piece"
  end

  def check_for_command(command)
    case command
    when 'EXIT'
      exit
    when 'DRAW'
      exit
    when 'CASTLE'
      puts 'castling'
      true
      # castling function
    when 'SAVE'
      puts 'saving game'
      true
      # save function
    when 'LOAD'
      puts 'loading game'
      true
      # load function
    end
  end

  def move_piece(location)
    new_pos = input_to_row_column(@location[1], @location[0])
    update_board(@current_pos, new_pos)
  end

  def update_board(row, col, row_new, col_new)
    # Moves piece to new location
    @chess_board.board[row_new][col_new] = @chess_board.board[row][col]
    # Replaces old location with a blank
    @chess_board.board[row][col] = Piece.new(@chess_board.blank)
  end

  def log_move
    #update log
    @chess_board.log += "#{@log1} #{@log2},"
    @log = @chess_board.log
  end

  def welcome_message
    puts 'Welcome Chess!'
    puts "Please use explicit syntax to move pieces.\n\n"
    puts "First select the piece you would like to move eg. 'a2'"
    puts "Then when prompted select where you would like to move that piece eg. 'a4'\n\n"
    puts "You can save, load, or exit your game by typing 'save', 'load', or 'exit'"
    puts "You can also propose a draw by entering 'draw'."
    puts 'Good luck!'
  end

  def clear_display
    # system('clear') || system('clc')
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
      puts "log:#{@log}"
      user_input
      change_player
      clear_display
      display_board
    end
  end
end

chess_game = Chess.new
chess_game.game
