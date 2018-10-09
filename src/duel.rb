require 'pry'
require 'colorize'

require_relative './bot_logic'
require_relative './light_bikes_client'

client = LightBikesClient.new
client.create_new_game

p_one = Process.fork do
  puts "Starting first bot..."
  run(game_id: client.game_id, name: 'Flynn', log_prefix: 'Bot 1')
  puts "Exited first bot"
end

p_two = Process.fork do
  puts "Starting second bot..."
  run(game_id: client.game_id, name: 'Clu', log_prefix: 'Bot 2')
  puts "Exited second bot"
end

Process.waitall
