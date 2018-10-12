class BotLogic
  attr_reader :client, :debug

  def initialize(
    server_uri:,
    game_id: nil,
    player_count: nil,
    test_game: false,
    name: 'Flynn',
    log_prefix: nil,
    difficulty: nil,
    debug: false
  )
    @debug = debug
    @client = LightBikesClient.new(
      name: name,
      game_id: game_id,
      test_game: test_game,
      log_prefix: log_prefix,
      player_count: player_count,
      server_uri: server_uri,
      difficulty: difficulty
    )
  end

  def player
    client.player
  end

  def opponent
    client.opponents.values.first
  end
  
  def board
    client.board
  end

  def all_points
    client.all_points
  end

  def open_areas
    client.open_areas
  end

  def run!
    if client.join_game
      on_join

      loop do
        if client.winner
          client.log(client.has_won? ? 'I won!' : 'I lost :(')
          break
        end

        move = find_best_move

        break unless move && client.make_move(move.x, move.y)
      end
    end
  end

  def on_join
    # no-op
  end

  def find_best_move
    # YOLO!
    move = available_moves.sample

    # If we haven't found someting yet I guess we're dead! Take the first move
    move || available_moves(all: true).first
  end

  # Determines if moving to the given coordinate would keep us alive
  def is_legit_move?(move)
    return all_points[move].nil?
  end

  # Find all possible moves that would keep us alive
  def available_moves(position = player.position, all: false)
    [
      Point.new(position.x - 1, position.y),
      Point.new(position.x, position.y - 1),
      Point.new(position.x + 1, position.y),
      Point.new(position.x, position.y + 1),
    ].select { |point| all || is_legit_move?(point) }
  end

  def safe_moves(all: false)
    available_moves(all: all).reject {|m| !all && causes_death?(m) }
  end

  # Determines if we're guaranteed to die in the given position
  def causes_death?(move)
    available_moves(move).empty?
  end
end
