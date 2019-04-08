class Piece
  attr_accessor :colour, :appearance

  def initialize(appearance, colour = nil)
    @colour = colour
    @appearance = appearance
  end
end

class Pawn < Piece

end

class Knight < Piece

end

class King < Piece

end

class Queen < Piece

end

class Bishop < Piece

end

class Rook < Piece

end
