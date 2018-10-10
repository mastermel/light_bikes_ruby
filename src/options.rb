# frozen_string_literal: true

require 'optparse'

# Class for parsing and containing command line options passed to the bot
class BotOptions
  attr_reader :game_id, :name, :test_game, :player_count, :server_uri

  def parse!
    OptionParser.new do |opts|
      opts.banner = 'Usage: bot.rb [options]'

      opts.on('--help', 'Prints this help') do
        puts opts
        exit
      end

      opts.on('-sSERVER', '--server-url=SERVER', 'The base URI for the server to connect to (defaults to localhost:8080).') do |v|
        @server_uri = v || 'localhost:8080'
      end

      opts.on('-gGAMEID', '--game-id=GAMEID', 'Game ID to connect to. Will create new game if absent.') do |v|
        @game_id = v
      end

      opts.on('-pPLAYERCOUNT', '--players=PLAYERCOUNT', Integer, 'Number of players to create a game for.') do |v|
        @player_count = v
      end

      opts.on('-t', '--test', "If creating a new game, creates it against the server's test bot.") do |v|
        @test_game = !!v
      end

      opts.on('-nNAME', '--name=NAME', 'The name your bot will be assuming.') do |v|
        @game_id = v
      end
    end.parse!
  end
end
