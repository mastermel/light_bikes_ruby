class RaiderLogic < BotLogic
  attr_reader :objective, :last_dir

  def initialize(options)
    super(options)

    @objective = :get_to_the_center
  end

  def on_join
    client.log('Getting to the center!')
  end

  def find_best_move
    sleep 0.125

    if objective == :get_to_the_center
      move = move_to_the_center
      unless move
        @objective = :hunt
        client.log('Hunting...')
      end
    end

    if objective == :hunt
      move = move_to_oponnent
      unless move
        @objective = :kill
        client.log('Killing...')
      end
    end

    if objective == :kill
      move = cut_off_oponnent
      unless move
        @objective = :survive
        client.log('Staying alive!')
      end
    end

    if objective == :survive
      move = move_to_survive
    end

    # YOLO!
    move ||= available_moves.sample

    # If we haven't found someting yet I guess we're dead! Take the first move
    move ||= available_moves(true).first

    @last_dir = move.dir_from(player.position)
    move
  end

  def move_to_the_center
    distance_to_center = player.position.distance_to(center_point)

    available_moves
      .select {|m| m.distance_to(center_point) < distance_to_center }
      .sort_by! {|m| (m.dir_from(player.position) == last_dir) ? 1 : 0 }
      .first
  end

  def move_to_oponnent
    distance_to_opponent = player.position.distance_to(opponent.position)

    available_moves
      .select { |m|
        d = m.distance_to(opponent.position)
        d > 2 && d < distance_to_opponent
      }
      .sort_by! {|m| (m.dir_from(player.position) == last_dir) ? 1 : 0 }
      .first
  end

  def cut_off_oponnent
  end

  def move_to_survive
  end

  def center_point
    return @center_point if @center_point

    half = board.length / 2
    @center_point = Point.new(half, half)
  end
end
