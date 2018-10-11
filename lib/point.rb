# Class representing a point in a 2-dimensional plane
class Point
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def ==(other)
    if other.is_a?(Point)
      x == other.x && y == other.y
    elsif other.is_a?(Array) && other.length >= 2
      x == other[0] && y == other[1]
    end
  end

  def eql?(other)
    self == other
  end

  def hash
    [ x, y ].hash
  end
end

class Array
  def to_p
    Point.new(self[0], self[1])
  end
end
