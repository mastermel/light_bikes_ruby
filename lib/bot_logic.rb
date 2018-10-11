# Do it!
def run(
  server_uri:,
  game_id: nil,
  player_count: nil,
  test_game: false,
  name: 'Flynn',
  log_prefix: nil,
  debug: false
)

  Thread.current[:debug] = debug

  client = LightBikesClient.new(
    name: name,
    game_id: game_id,
    test_game: test_game,
    log_prefix: log_prefix,
    player_count: player_count,
    server_uri: server_uri,
  )

  if client.join_game
    loop do
      if client.winner
        client.log(client.has_won? ? 'I won!' : 'I lost :(')
        break
      end

      move = find_best_move(client)

      break unless move && client.make_move(move.x, move.y)
    end
  end
end

def find_best_move(client)
  # YOLO!
  move = available_moves(client).sample

  # If we haven't found someting yet I guess we're dead! Take the first move
  move || available_moves(client, true).first
end

# Determines if moving to the given coordinate would keep us alive
def is_legit_move?(client, point)
  return client.all_points[point].nil?
end

# Find all possible moves that would keep us alive
def available_moves(client, include_all = false)
  player = client.player
  [
    Point.new(player.x - 1, player.y),
    Point.new(player.x + 1, player.y),
    Point.new(player.x, player.y - 1),
    Point.new(player.x, player.y + 1),
  ].select { |point| include_all || is_legit_move?(client, point) }
end
