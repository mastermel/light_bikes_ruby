require 'pry'
require_relative './light_bikes_client'

# Do it!
def run(server_uri: 'localhost:8080', game_id: nil, player_count: nil, test_game: false, name: 'Flynn', log_prefix: nil)
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

      # YOLO!
      move = available_moves(client.board, client.player).sample

      # I guess we're dead! Take the first move
      move = move || available_moves(client.board, client.player, true).first

      break unless move && client.make_move(move[0], move[1])
    end
  end
end

# Determines if moving to the given coordinate would keep us alive
def is_legit_move?(board, x, y)
  return x >= 0 && y >= 0 &&
    x < board.length && y < board.length &&
    board[x][y].nil?
end

# Find all possible moves that would keep us alive
def available_moves(board, player, include_all = false)
  [
    [player['x'] - 1, player['y']],
    [player['x'] + 1, player['y']],
    [player['x'], player['y'] - 1],
    [player['x'], player['y'] + 1],
  ].select { |x,y| include_all || is_legit_move?(board, x, y) }
end
