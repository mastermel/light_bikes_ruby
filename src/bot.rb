require 'pry'

require_relative './options'
require_relative './bot_logic'

options = BotOptions.new
options.parse!

run(
  name: options.name,
  game_id: options.game_id
)
