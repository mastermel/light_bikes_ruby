class Player
  attr_reader :id, :name, :color, :position, :alive, :last_diff

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

  def update_position(json)
    new_point = Point.new(json['x'], json['y'])
    @last_diff = position - new_point
    @position = new_point
  end
end
