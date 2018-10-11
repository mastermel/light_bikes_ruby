# frozen_string_literal: true

require 'pry'
require 'httparty'
require 'colorize'

# Class encapsulating all API calls to the light_bikes server.
class LightBikesClient
  include HTTParty

  attr_reader :game_id, 
    :name,
    :player,
    :player_count,
    :board,
    :winner,
    :log_prefix,
    :test_game,
    :all_points,
    :opponents,
    :open_areas,
    :difficulty

  def initialize(
    server_uri:,
    game_id: nil,
    player_count: nil,
    test_game: false,
    name: 'Flynn',
    log_prefix: nil,
    difficulty: nil
  )
    self.class.base_uri(server_uri)

    @name = name
    @game_id = game_id
    @test_game = test_game
    @log_prefix = log_prefix
    @player_count = player_count
    @difficulty = difficulty

    @opponents = {}
    @all_points = Hash.new(:wall) 
    @open_areas = []
  end

  def join_game
    create_new_game unless game_id

    log 'Joining game...'

    response = post("/games/#{game_id}/join", {
      name: name
    })

    unless response.success? && response.any?
      log 'Failed to join game!'
      log response.to_s
      return false
    end

    parse_game_state(response)

    log "Ready #{player.color.capitalize} Player #{player.id}"
    true
  end

  def create_new_game
    log test_game ? 'Creating new game against test bot...' : 'Creating new game...'

    params = {}
    params[:addServerBot] = test_game
    params[:numPlayers] = player_count unless player_count.nil?
    params[:serverBotDifficulty] = difficulty unless difficulty.nil?
    response = post('/games', params)

    unless response.success?
      log 'Failed to create game!'
      log response.to_s
      return false
    end

    @game_id = response['id']

    log "New Game ID: #{game_id}"
  end

  def make_move(x, y)
    log "Moving to #{x}-#{y}"

    response = post("/games/#{game_id}/move", {
      playerId: player.id,
      x: x,
      y: y
    })

    unless response.success? && response.any?
      log 'Failed to make a move!'
      log response.to_s
      return false
    end

    parse_game_state(response)
    true
  end

  def has_won?
    winner == player.color
  end

  def log(message)
    message = "#{log_prefix}: #{message}" if log_prefix
    message = message.send(player.color) if player && player.color
    puts message
  end

  private

  def parse_current_player(response)
    return if player && player.id != response['current_player']['id']

    @player = Player.new(response['current_player'])
  end

  def parse_all_points(response)
    board = response['board']

    # Set the walls unless we've already done that
    unless all_points.any?
      i = 0
      while i < board.length do
        all_points[Point.new(-1, i)] = :wall
        all_points[Point.new(i, -1)] = :wall
        all_points[Point.new(board.length, i)] = :wall
        all_points[Point.new(i, board.length)] = :wall
        i += 1
      end
    end

    board.each_with_index do |row, x|
      row.each_with_index do |color, y|
        all_points[Point.new(x,y)] = color
      end
    end
  end

  def parse_opponents(response)
    response['players'].each do |p|
      if p['color'] != player.color
        opponents[p['color']] = Player.new(p) unless opponents.key?(p['color'])
        opponents[p['color']].update_position(p)
      end
    end
  end

  def parse_game_state(response)
    # Hack for when the game object comes in an array
    response = response[0] unless response.key?('board')

    @board = response['board']
    @winner = response['winner']

    parse_current_player(response)
    parse_opponents(response)
    parse_all_points(response)
    @open_areas = get_open_areas
  end

  def get_open_areas
    areas = []
    visited = {}

    0.upto(board.length - 1) do |x|
      0.upto(board.length - 1) do |y|
        p = Point.new(x,y)
        if all_points[p].nil? && !visited[p]
          areas << deep_search(p, visited)
        end
      end
    end

    areas
  end

  def deep_search(point, visited)
    area = [point]
    visited[point] = true

    rowNbr = [-1, -1, -1, 0, 0, 1, 1, 1]
    colNbr = [-1, 0, 1, -1, 1, -1, 0, 1]

    0.upto(7) do |k|
      p = Point.new(point.x + rowNbr[k], point.y + colNbr[k])
      if all_points[p].nil? && !visited[p]
        area.push(*deep_search(p, visited))
      end
    end

    area
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
