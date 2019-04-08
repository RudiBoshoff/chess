class Piece

attr_accessor :colour, :appearance

  def initialize(appearance, colour = nil)
    @colour = colour
    @appearance = appearance
  end

end

class Pawn < Piece

  def initialize(appearance, colour = nil)
    super
  end


end

class Knight < Piece

  def initialize(appearance, colour = nil)
    super
  end

end

class Bishop < Piece

  def initialize(appearance, colour = nil)
    super
  end

end

class Rook < Piece

  def initialize(appearance, colour = nil)
    super
  end

end

class Queen < Piece

  def initialize(appearance, colour = nil)
    super
  end

end

class King < Piece

  def initialize(appearance, colour = nil)
    super
  end

end
