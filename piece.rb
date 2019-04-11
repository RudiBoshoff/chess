class Piece
  attr_accessor :colour, :appearance

  def initialize(appearance, colour = nil)
    @colour = colour
    @appearance = appearance
  end
end

class Pawn < Piece
  def possible_moves(row, col)
    first_move = []

    if self.colour == 'white'
      # pawn first move
      first_move << [row - 2, col]
      # normal moves
      next_row = row - 1
      valid_moves = [[next_row, col -1],[next_row, col],[next_row, col + 1]]
    else
      # pawn first move
      first_move << [row + 2, col]
      # normal moves
      next_row = row + 1
      valid_moves = [[next_row, col -1],[next_row, col],[next_row, col + 1]]
    end
    valid_moves = first_move + valid_moves
  end
end

class Knight < Piece
  def possible_moves(row, col)
    valid_moves = [[row + 2, col + 1],[row + 1, col + 2],[row - 1, col + 2],[row - 2, col + 1],
                  [row - 2, col - 1],[row - 1, col - 2],[row + 1, col - 2],[row + 2, col - 1]]
  end
end

class King < Piece
  def possible_moves(row, col)
    valid_moves = [[row + 1, col - 1], [row + 1, col],[row + 1, col + 1],[row, col + 1],
                  [row - 1, col + 1], [row - 1, col],[row - 1, col - 1],[row - 1, col - 1]]
  end
end

class Queen < Piece
  def possible_moves(row, col)
    # diagonal /
    r = row
    c = col
    diagonal_first = []
    until c > 8
      diagonal_first << [r, c]
      r += 1
      c += 1
    end

    r = row
    c = col
    until c < 1
      diagonal_first << [r, c]
      r -= 1
      c -= 1
    end

    #diagonal \
    r = row
    c = col
    diagonal_second = []
    until c > 8
      diagonal_second << [r, c]
      r -= 1
      c += 1
    end

    r = row
    c = col

    until c < 1
      diagonal_second << [r, c]
      r += 1
      c -= 1
    end

    # vertically
    r = 0
    vertical_moves = []
    until r > 7
      vertical_moves << [r, col]
      r += 1
    end

    #horizontally
    c = 1
    horizontal_moves = []
    until c > 8
      horizontal_moves << [row, c]
      c += 1
    end

    valid_moves = horizontal_moves + vertical_moves + diagonal_first + diagonal_second
  end
end

class Bishop < Piece
  def possible_moves(row, col)
    # diagonal /
    r = row
    c = col
    diagonal_first = []
    until c > 8
      diagonal_first << [r, c]
      r += 1
      c += 1
    end

    r = row
    c = col
    until c < 1
      diagonal_first << [r, c]
      r -= 1
      c -= 1
    end

    #diagonal \
    r = row
    c = col
    diagonal_second = []
    until c > 8
      diagonal_second << [r, c]
      r -= 1
      c += 1
    end

    r = row
    c = col

    until c < 1
      diagonal_second << [r, c]
      r += 1
      c -= 1
    end
    valid_moves = diagonal_first + diagonal_second
  end
end

class Rook < Piece
  def possible_moves(row, col)
    # vertically
    r = 0
    vertical_moves = []
    until r > 7
      vertical_moves << [r, col]
      r += 1
    end

    #horizontally
    c = 1
    horizontal_moves = []
    until c > 8
      horizontal_moves << [row, c]
      c += 1
    end

    valid_moves = horizontal_moves + vertical_moves
  end
end
