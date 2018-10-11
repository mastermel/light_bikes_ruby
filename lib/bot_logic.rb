class BotLogic
  attr_reader :client

  def initialize(
    server_uri:,
    game_id: nil,
    player_count: nil,
    test_game: false,
    name: 'Flynn',
    log_prefix: nil,
    debug: false
  )
    @client = LightBikesClient.new(
      name: name,
      game_id: game_id,
      test_game: test_game,
      log_prefix: log_prefix,
      player_count: player_count,
      server_uri: server_uri,
    )
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
    move || available_moves(true).first
  end

  # Determines if moving to the given coordinate would keep us alive
  def is_legit_move?(point)
    return client.all_points[point].nil?
  end

  # Find all possible moves that would keep us alive
  def available_moves(include_all = false)
    player = client.player
    [
      Point.new(player.x - 1, player.y),
      Point.new(player.x + 1, player.y),
      Point.new(player.x, player.y - 1),
      Point.new(player.x, player.y + 1),
    ].select { |point| include_all || is_legit_move?(point) }
  end
end
