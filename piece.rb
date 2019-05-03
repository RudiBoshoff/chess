# Rudi Boshoff
class Piece
  attr_accessor :colour, :appearance

  def initialize(appearance, colour = nil)
    @colour = colour
    @appearance = appearance
  end

  def simplify_moves(moves, board)
    # Removes moves that are out of bounds
    moves.uniq.delete_if do |move|
      move[1] > 8 || move[1] < 1 ||
        move[0] < 0 || move[0] > 7 ||
        board[move[0]][move[1]].colour == colour
    end
  end

  def delete_self(row, col, moves, _board)
    # Prevents user from moving piece to current location
    moves.uniq.delete_if do |coordinate|
      coordinate == [row, col]
    end.sort!
  end
end

class Pawn < Piece
  def possible_moves(row, col, board)
    first_move = []
    # White
    if colour == 'white'
      # Pawn first move
      if row == 6
        if board[row - 1][col].class.to_s == 'Piece' && board[row - 2][col].class.to_s == 'Piece'
          first_move << [row - 2, col]
        end
      end

      # Pawn normal moves
      next_row = row - 1
      moves = [[next_row, col - 1], [next_row, col + 1]]
      moves << [next_row, col] if board[next_row][col].class.to_s == 'Piece'
    else
      # Black
      # Pawn first move
      if row == 1
        if board[row + 1][col].class.to_s == 'Piece' && board[row + 2][col].class.to_s == 'Piece'
          first_move << [row + 2, col]
        end
      end

      # Pawn normal moves
      next_row = row + 1
      moves = [[next_row, col - 1], [next_row, col + 1]]
      moves << [next_row, col] if board[next_row][col].class.to_s == 'Piece'
    end

    moves = first_move + moves
    moves = simplify_moves(moves, board)
    moves = delete_self(row, col, moves, board)
  end
end

class Knight < Piece
  def possible_moves(row, col, board)
    moves = [[row + 2, col + 1], [row + 1, col + 2], [row - 1, col + 2], [row - 2, col + 1],
             [row - 2, col - 1], [row - 1, col - 2], [row + 1, col - 2], [row + 2, col - 1]]

    moves = simplify_moves(moves, board)

    moves = delete_self(row, col, moves, board)
  end
end

class King < Piece
  def possible_moves(row, col, board)
    moves = [[row + 1, col - 1], [row + 1, col], [row + 1, col + 1], [row, col + 1],
             [row - 1, col + 1], [row - 1, col], [row, col - 1], [row - 1, col - 1]]

    moves = simplify_moves(moves, board)
    moves = delete_self(row, col, moves, board)
  end
end

class Queen < Piece
  def possible_moves(row, col, board)
    # Queen
    # Diagonal /
    r = row
    c = col
    diagonal_first = []
    until c > 8
      diagonal_first << [r, c]
      r += 1
      c += 1
      next unless r <= 7 && c <= 8

      piece_type = board[r][c].class.to_s
      if piece_type != 'Piece' && piece_type != 'King'
        diagonal_first << [r, c]
        break
      end
    end

    # Queen
    # Diagonal /
    r = row
    c = col
    until c < 1
      diagonal_first << [r, c]
      r -= 1
      c -= 1
      next unless r >= 0 && c >= 1

      piece_type = board[r][c].class.to_s
      if piece_type != 'Piece' && piece_type != 'King'
        diagonal_first << [r, c]
        break
      end
    end

    # Queen
    # Diagonal \
    r = row
    c = col
    diagonal_second = []
    until c > 8
      diagonal_second << [r, c]
      r -= 1
      c += 1
      next unless r >= 0 && c <= 8

      piece_type = board[r][c].class.to_s
      if piece_type != 'Piece' && piece_type != 'King'
        diagonal_first << [r, c]
        break
      end
    end

    # Queen
    # Diagonal \
    r = row
    c = col
    until c < 1
      diagonal_second << [r, c]
      r += 1
      c -= 1
      next unless r <= 7 && c >= 1

      piece_type = board[r][c].class.to_s
      if piece_type != 'Piece' && piece_type != 'King'
        diagonal_first << [r, c]
        break
      end
    end

    # Queen
    # Vertically up
    r = row
    vertical_moves = []
    until r > 7
      vertical_moves << [r, col]
      r += 1
      next unless r <= 7

      piece_type = board[r][col].class.to_s
      if piece_type != 'Piece' && piece_type != 'King'
        vertical_moves << [r, col]
        break
      end
    end

    # Queen
    # Vertically down
    r = row
    until r < 0
      vertical_moves << [r, col]
      r -= 1
      next unless r >= 0

      piece_type = board[r][col].class.to_s
      if piece_type != 'Piece' && piece_type != 'King'
        vertical_moves << [r, col]
        break
      end
    end

    # Queen
    # Horizontally right
    c = col
    horizontal_moves = []
    until c > 8
      horizontal_moves << [row, c]
      c += 1
      next unless c <= 8

      piece_type = board[row][c].class.to_s
      if piece_type != 'Piece' && piece_type != 'King'
        horizontal_moves << [row, c]
        break
      end
    end

    # Queen
    # Horizontally left
    c = col
    until c < 1
      horizontal_moves << [row, c]
      c -= 1
      next unless c >= 1

      piece_type = board[row][c].class.to_s
      if piece_type != 'Piece' && piece_type != 'King'
        horizontal_moves << [row, c]
        break
      end
    end

    # Combines moves
    moves = horizontal_moves + vertical_moves + diagonal_first + diagonal_second
    moves = simplify_moves(moves, board)
    moves = delete_self(row, col, moves, board)
  end
end

class Bishop < Piece
  def possible_moves(row, col, board)
    # Bishop
    # Diagonal /
    r = row
    c = col
    diagonal_first = []
    until c > 8
      diagonal_first << [r, c]
      r += 1
      c += 1
      next unless r <= 7 && c <= 8

      piece_type = board[r][c].class.to_s
      if piece_type != 'Piece' && piece_type != 'King'
        diagonal_first << [r, c]
        break
      end
    end

    # Bishop
    # Diagonal /
    r = row
    c = col
    until c < 1
      diagonal_first << [r, c]
      r -= 1
      c -= 1
      next unless r >= 0 && c >= 1

      piece_type = board[r][c].class.to_s
      if piece_type != 'Piece' && piece_type != 'King'
        diagonal_first << [r, c]
        break
      end
    end

    # Bishop
    # Diagonal \
    r = row
    c = col
    diagonal_second = []
    until c > 8
      diagonal_second << [r, c]
      r -= 1
      c += 1
      next unless r >= 0 && c <= 8

      piece_type = board[r][c].class.to_s
      if piece_type != 'Piece' && piece_type != 'King'
        diagonal_first << [r, c]
        break
      end
    end

    # Bishop
    # Diagonal \
    r = row
    c = col
    until c < 1
      diagonal_second << [r, c]
      r += 1
      c -= 1
      next unless r <= 7 && c >= 1

      piece_type = board[r][c].class.to_s
      if piece_type != 'Piece' && piece_type != 'King'
        diagonal_first << [r, c]
        break
      end
    end

    # Combines moves
    moves = diagonal_first + diagonal_second
    moves = simplify_moves(moves, board)
    moves = delete_self(row, col, moves, board)
  end
end

class Rook < Piece
  def possible_moves(row, col, board)
    # Rook
    # Vertically up
    r = row
    vertical_moves = []
    until r > 7
      vertical_moves << [r, col]
      r += 1
      next unless r <= 7

      piece_type = board[r][col].class.to_s
      if piece_type != 'Piece' && piece_type != 'King'
        vertical_moves << [r, col]
        break
      end
    end

    # Rook
    # Vertically down
    r = row
    until r < 0
      vertical_moves << [r, col]
      r -= 1
      next unless r >= 0

      piece_type = board[r][col].class.to_s
      if piece_type != 'Piece' && piece_type != 'King'
        vertical_moves << [r, col]
        break
      end
    end

    # Rook
    # Horizontally right
    c = col
    horizontal_moves = []
    until c > 8
      horizontal_moves << [row, c]
      c += 1
      next unless c <= 8

      piece_type = board[row][c].class.to_s
      if piece_type != 'Piece' && piece_type != 'King'
        horizontal_moves << [row, c]
        break
      end
    end

    # Rook
    # Horizontally left
    c = col
    until c < 1
      horizontal_moves << [row, c]
      c -= 1
      next unless c >= 1

      piece_type = board[row][c].class.to_s
      if piece_type != 'Piece' && piece_type != 'King'
        horizontal_moves << [row, c]
        break
      end
    end

    # Combines moves
    moves = horizontal_moves + vertical_moves
    moves = simplify_moves(moves, board)
    moves = delete_self(row, col, moves, board)
  end
end
