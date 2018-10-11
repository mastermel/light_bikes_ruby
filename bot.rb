require_relative './lib/lib'

options = BotOptions.new
options.parse!

RaiderLogic.new(
  name: options.name,
  game_id: options.game_id,
  player_count: options.player_count,
  test_game: options.test_game,
  server_uri: options.server_uri,
  difficulty: options.difficulty,
).run!
