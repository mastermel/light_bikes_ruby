require 'pry'

require_relative './options'
require_relative './bot_logic'

options = BotOptions.new
options.parse!

run(
  name: options.name || `whoami`.strip,
  game_id: options.game_id,
  test_game: options.test_game,
)
