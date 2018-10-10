require 'pry'
require 'colorize'

require_relative './options'
require_relative './bot_logic'
require_relative './light_bikes_client'

options = BotOptions.new
options.parse!

client = LightBikesClient.new(
  server_uri: options.server_uri,
  player_count: options.player_count,
)
client.create_new_game

count = options.player_count || 2

names = [
  "Flynn",
  "Clu",
  "Tron",
  "Quorra",
]

i = 1
while i <= count do
  Process.fork do
    puts "Starting bot #{i}..."
    run(
      server_uri: options.server_uri,
      game_id: client.game_id,
      name: names[i-1],
      log_prefix: "Bot #{i}"
    )
    puts "Exited bot #{i}"
  end

  i += 1
end

Process.waitall
