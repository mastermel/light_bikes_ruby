# frozen_string_literal: true

require 'pry'
require 'httparty'
require 'colorize'

# Class encapsulating all API calls to the light_bikes server.
class LightBikesClient
  include HTTParty

  base_uri 'localhost:8080'

  attr_reader :game_id, 
    :name,
    :player,
    :board,
    :winner,
    :log_prefix,
    :test_game

  def initialize(game_id: nil, test_game: false, name: 'Flynn', log_prefix: nil)
    @name = name
    @game_id = game_id
    @test_game = test_game
    @log_prefix = log_prefix
  end

  def join_game
    create_new_game unless game_id

    log 'Joining game...'

    response = post("/games/#{game_id}/join", {
      name: name
    })

    unless response.success? && response.any?
      log 'Failed to join game!'
      log response
      return false
    end

    parse_game_state(response)

    log "Ready #{player['color'].capitalize} Player #{player['id']}"
    true
  end

  def create_new_game(playerCount = nil)
    log test_game ? 'Creating new game against test bot...' : 'Creating new game...'

    params = {}
    params[:test] = test_game
    params[:numPlayers] = playerCount unless playerCount.nil?
    response = post('/games', params)
    @game_id = response['id']

    log "New Game ID: #{game_id}"
  end

  def make_move(x, y)
    log "Moving to #{x}-#{y}"

    response = post("/games/#{game_id}/move", {
      id: player['id'],
      x: x,
      y: y
    })

    unless response.success? && response.any?
      log 'Failed to make a move!'
      log response
      return false
    end

    parse_game_state(response)
    true
  end

  def has_won?
    winner == player['color']
  end

  def log(message)
    message = "#{log_prefix}: #{message}" if log_prefix
    message = message.send(player['color']) if player && player['color']
    puts message
  end

  private

  def parse_current_player(response)
    return if player && player['id'] != response['current_player']['id']

    @player = response['current_player']
  end

  def parse_game_state(response)
    # Hack for when the game object comes in an array
    response = response[0] unless response.key?('board')

    @board = response['board']
    @winner = response['winner']

    parse_current_player(response)
  end

  def get(*args)
    self.class.get(*args)
  end

  def post(uri, query = {})
    self.class.post(uri, {
      query: query
    })
  end
end
