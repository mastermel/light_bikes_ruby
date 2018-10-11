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
    move ||= safe_moves.sample

    # If we haven't found someting yet I guess we're dead! Take the first move
    move ||= available_moves.first
    move ||= available_moves(all: true).first

    @last_dir = move.dir_from(player.position)
    move
  end

  def move_to_the_center
    distance_to_center = player.position.distance_to(center_point)

    safe_moves
      .select {|m| m.distance_to(center_point) < distance_to_center }
      .sort_by {|m| (m.dir_from(player.position) == last_dir) ? 1 : 0 }
      .first
  end

  def move_to_oponnent
		return if next_to_edge

    distance_to_opponent = player.position.distance_to(opponent.position).to_i
    lead_space = [distance_to_opponent, 2].min
    opponent_bead = opponent.position -
      Point.new(
        (opponent.last_diff.x * lead_space),
        (opponent.last_diff.y * lead_space)
      )
    distance_to_bead = player.position.distance_to(opponent_bead)

    safe_moves
      .select {|m| m.distance_to(opponent_bead) < distance_to_bead }
      .sort_by {|m| (m.dir_from(player.position) == last_dir) ? 1 : 0 }
      .first
  end

  def cut_off_oponnent
    return if next_to_edge

    safe_moves
      .sort_by {|m| (m.dir_from(player.position) == last_dir) ? 0 : distance_to_edge(m - player.position) }
      .first
  end

  def move_to_survive
    moves = safe_moves
    moves.sort_by! {|m| -area_size_for(m) } if moves.length == 2
    moves.first
  end

  def next_to_edge
    safe_moves(all: true).any? {|m| !all_points[m].nil? && all_points[m] != player.color }
  end

  def area_size_for(move)
    area = open_areas.find {|a| a.include?(move) }
    area.nil? ? 0 : area.length
  end

  def distance_to_edge(delta)
    dist = 0
    test = player.position

    loop do
      test += delta
      break unless client.all_points[test].nil?
      dist += 1
    end

    dist
  end

  def center_point
    return @center_point if @center_point

    half = board.length / 2
    @center_point = Point.new(half, half)
  end
end
