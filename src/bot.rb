require 'pry'

require_relative './options'
require_relative './bot_logic'

options = BotOptions.new
options.parse!

run(
  name: options.name || `whoami`.strip,
  game_id: options.game_id,
  player_count: options.player_count,
  test_game: options.test_game,
  server_uri: options.server_uri,
)
