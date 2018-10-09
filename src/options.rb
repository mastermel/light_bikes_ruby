# frozen_string_literal: true

require 'optparse'

# Class for parsing and containing command line options passed to the bot
class BotOptions
  attr_reader :game_id, :name

  def parse!
    OptionParser.new do |opts|
      opts.banner = 'Usage: bot.rb [options]'

      opts.on('--help', 'Prints this help') do
        puts opts
        exit
      end

      opts.on('-gGAMEID', '--game-id=GAMEID', 'Game ID to connect to. Will create new game if absent.') do |v|
        @game_id = v
      end

      opts.on('-nNAME', '--name=NAME', 'The name your bot will be assuming.') do |v|
        @game_id = v
      end
    end.parse!
  end
end
