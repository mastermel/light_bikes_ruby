require 'pry'
require 'colorize'

require_relative './options'
require_relative './bot_logic'
require_relative './light_bikes_client'

options = BotOptions.new
options.parse!

client = LightBikesClient.new
client.create_new_game(options.player_count)

count = options.player_count || 2

names = %w[
  Flynn
  Clu
  Tron
  Quorra
]

i = 1
while i <= count do
  Process.fork do
    puts "Starting bot #{i}..."
    run(game_id: client.game_id, name: names[i-1], log_prefix: "Bot #{i}")
    puts "Exited bot #{i}"
  end

  i += 1
end

Process.waitall
