class Piece

attr_accessor :colour, :type, :position_x, :position_y

  def initialize(colour, type, position_x, position_y)
    @colour = colour
    @type = type
    @position_x = position_x
    @position_y = position_y
  end

end

class Pawn < Piece

  def initialize(color, symbol, column, row)
    super
  end

end

class Knight < Piece

  def initialize(color, symbol, column, row)
    super
  end

end

class Bishop < Piece

  def initialize(color, symbol, column, row)
    super
  end

end

class Rook < Piece

  def initialize(color, symbol, column, row)
    super
  end

end

class Queen < Piece

  def initialize(color, symbol, column, row)
    super
  end

end

class King < Piece

  def initialize(color, symbol, column, row)
    super
  end

end
