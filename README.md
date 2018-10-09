# light_bikes_ruby
A bot for [davishyer/light_bikes](https://github.com/davishyer/light_bikes) written in Ruby.

The actual AI for the bot is contained inside *./src/bot_logic.rb*. All interaction with the server
is inside *./src/light_bikes_client.rb*.

# Start
`bundle install`
`ruby ./src/bot.rb -t`

## Set your name
`ruby ./src/bot.rb -n Tron`

## Join a predefined game
`ruby ./src/bot.rb -g <gameID>`

## Run the bot logic against itself
`ruby ./src/duel.rb`

# Help
`ruby ./src/bot.rb -h`

