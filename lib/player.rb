class Player
  attr_reader :id, :name, :color, :position, :alive

  def initialize(json)
    @id = json['id']
    @name = json['name']
    @color = json['color']
    @alive = json['alive']
    @position = Point.new(json['x'], json['y'])
  end

  def x
    position.x
  end

  def y
    position.y
  end
end
