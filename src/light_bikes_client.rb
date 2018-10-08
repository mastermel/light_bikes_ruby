# frozen_string_literal: true

require 'httparty'

# Class encapsulating all API calls to the light_bikes server.
class LightBikesClient
  include HTTParty

  base_uri 'localhost:8080'

  attr_reader :game_id, :player_id, :color

  def initialize(game_id = nil)
    @game_id = game_id
  end

  def join_game
    create_new_game unless game_id

    puts 'Joining game...'

    response = post("/games/#{game_id}/join", {
      name: "Flynn"
    })

    unless response.success?
      puts 'Failed to join game!'
      puts response
      return false
    end

    player_id = response['id']
    color = response['color']
    puts "Ready Player #{player_id}?"
    true
  end

  def create_new_game
    puts 'Creating new game...'

    response = post('/games')
    @game_id = response['id']

    puts "New Game ID: #{game_id}"
  end

  def make_move(x, y)
    puts "Moving to #{x}-#{y}"

    response = post("/games/#{game_id}/move", {
      playerId: player_id,
      x: x,
      y: y
    })

    unless response.success?
      puts 'Failed to make a move!'
      puts response
      return false
    end

    true
  end

  private

  def get(*args)
    self.class.get(*args)
  end

  def post(uri, query = {})
    self.class.post(uri, {
      query: query
    })
  end
end
