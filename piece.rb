class Piece
  attr_accessor :colour, :appearance

  def initialize(appearance, colour = nil)
    @colour = colour
    @appearance = appearance
  end

  def simplify_moves(row, col, moves)
    moves.uniq.delete_if{|coordinate|
       coordinate == [row, col] ||
       coordinate[1] > 8 || coordinate[1] < 1 ||
       coordinate[0] < 0 || coordinate[0] > 7
    }.sort!
  end
end

class Pawn < Piece
  def possible_moves(row, col, board)
    first_move = []

    if self.colour == 'white'
      # pawn first move
      if row == 6
        if board[row - 1][col].class.to_s == "Piece" && board[row - 2][col].class.to_s == "Piece"
          first_move << [row - 2, col]
        end
      end

      # normal moves
      next_row = row - 1
      moves = [[next_row, col -1],[next_row, col],[next_row, col + 1]]
    else
      # pawn first move
      if row == 1
        if board[row + 1][col].class.to_s == "Piece" && board[row + 2][col].class.to_s == "Piece"
          first_move << [row + 2, col]
        end
      end

      # normal moves
      next_row = row + 1
      moves = [[next_row, col -1],[next_row, col],[next_row, col + 1]]
    end

    moves = first_move + moves
    moves = simplify_moves(row, col, moves)
  end
end

class Knight < Piece
  def possible_moves(row, col, board)
    moves = [[row + 2, col + 1],[row + 1, col + 2],[row - 1, col + 2],[row - 2, col + 1],
                  [row - 2, col - 1],[row - 1, col - 2],[row + 1, col - 2],[row + 2, col - 1]]

    moves = simplify_moves(row, col, moves)
  end
end

class King < Piece
  def possible_moves(row, col, board)
    moves = [[row + 1, col - 1], [row + 1, col],[row + 1, col + 1],[row, col + 1],
                  [row - 1, col + 1], [row - 1, col],[row, col - 1],[row - 1, col - 1]]

    moves = simplify_moves(row, col, moves)
  end
end

class Queen < Piece
  def possible_moves(row, col, board)
    # diagonal /
    r = row
    c = col
    diagonal_first = []
    until c > 8
      diagonal_first << [r, c]
      r += 1
      c += 1
      if r <= 7 && c <= 8
        if board[r][c].class.to_s != "Piece"
          break
        end
      end
    end

    r = row
    c = col
    until c < 1
      diagonal_first << [r, c]
      r -= 1
      c -= 1
      if r >= 0 && c >= 1
        if board[r][c].class.to_s != "Piece"
          break
        end
      end
    end

    #diagonal \
    r = row
    c = col
    diagonal_second = []
    until c > 8
      diagonal_second << [r, c]
      r -= 1
      c += 1
      if r >= 0 && c <= 8
        if board[r][c].class.to_s != "Piece"
          break
        end
      end
    end

    r = row
    c = col
    until c < 1
      diagonal_second << [r, c]
      r += 1
      c -= 1
      if r <= 7 && c >= 1
        if board[r][c].class.to_s != "Piece"
          break
        end
      end
    end

    # vertically up
    r = row
    vertical_moves = []
    until r > 7
      vertical_moves << [r, col]
      r += 1
      if r <= 7
        if board[r][col].class.to_s != "Piece"
          break
        end
      end
    end

    # vertically down
    r = row
    until r < 0
      vertical_moves << [r, col]
      r -= 1
      if r >= 0
        if board[r][col].class.to_s != "Piece"
          break
        end
      end
    end

    # horizontally right
    c = col
    horizontal_moves = []
    until c > 8
      horizontal_moves << [row, c]
      c += 1
      if c <= 8
        if board[row][c].class.to_s != "Piece"
          break
        end
      end
    end

    # horizontally left
    c = col
    until c < 1
      horizontal_moves << [row, c]
      c -= 1
      if c >= 1
        if board[row][c].class.to_s != "Piece"
          break
        end
      end
    end

    moves = horizontal_moves + vertical_moves + diagonal_first + diagonal_second

    moves = simplify_moves(row, col, moves)
  end
end

class Bishop < Piece
  def possible_moves(row, col, board)
    # diagonal /
    r = row
    c = col
    diagonal_first = []
    until c > 8
      diagonal_first << [r, c]
      r += 1
      c += 1
      if r <= 7 && c <= 8
        if board[r][c].class.to_s != "Piece"
          break
        end
      end
    end

    r = row
    c = col
    until c < 1
      diagonal_first << [r, c]
      r -= 1
      c -= 1
      if r >= 0 && c >= 1
        if board[r][c].class.to_s != "Piece"
          break
        end
      end
    end

    #diagonal \
    r = row
    c = col
    diagonal_second = []
    until c > 8
      diagonal_second << [r, c]
      r -= 1
      c += 1
      if r >= 0 && c <= 8
        if board[r][c].class.to_s != "Piece"
          break
        end
      end
    end

    r = row
    c = col
    until c < 1
      diagonal_second << [r, c]
      r += 1
      c -= 1
      if r <= 7 && c >= 1
        if board[r][c].class.to_s != "Piece"
          break
        end
      end
    end
    moves = diagonal_first + diagonal_second

    moves = simplify_moves(row, col, moves)
  end
end

class Rook < Piece
  def possible_moves(row, col, board)
    # vertically up
    r = row
    vertical_moves = []
    until r > 7
      vertical_moves << [r, col]
      r += 1
      if r <= 7
        if board[r][col].class.to_s != "Piece"
          break
        end
      end
    end

    # vertically down
    r = row
    until r < 0
      vertical_moves << [r, col]
      r -= 1
      if r >= 0
        if board[r][col].class.to_s != "Piece"
          break
        end
      end
    end

    # horizontally right
    c = col
    horizontal_moves = []
    until c > 8
      horizontal_moves << [row, c]
      c += 1
      if c <= 8
        if board[row][c].class.to_s != "Piece"
          break
        end
      end
    end

    # horizontally left
    c = col
    until c < 1
      horizontal_moves << [row, c]
      c -= 1
      if c >= 1
        if board[row][c].class.to_s != "Piece"
          break
        end
      end
    end

    moves = horizontal_moves + vertical_moves

    moves = simplify_moves(row, col, moves)

  end
end
