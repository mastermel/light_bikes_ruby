require_relative './options'
require_relative './light_bikes_client'

options = BotOptions.new
options.parse!

client = LightBikesClient.new(options.game_id)

if client.join_game
  
end
