class RaiderLogic < BotLogic
  attr_reader :objective

  def initialize(options)
    super(options)

    @objective = :get_to_the_center
  end

  def on_join
    client.log('Getting to the center!')
  end

  def find_best_move
    if objective == :get_to_the_center
      move = move_to_the_center
      unless move
        @objective = :hunt
        client.log('Hunting...')
      end
    end

    if objective == :hunt
      move = move_to_oponnent
      unless move
        @objective = :kill
        client.log('Killing...')
      end
    end

    if objective == :kill
      move = cut_off_oponnent
      unless move
        @objective = :survive
        client.log('Staying alive!')
      end
    end

    if objective == :survive
      move = move_to_survive
    end

    # YOLO!
    move ||= available_moves.sample

    # If we haven't found someting yet I guess we're dead! Take the first move
    move || available_moves(true).first
  end

  def move_to_the_center
  end

  def move_to_oponnent
  end

  def cut_off_oponnent
  end

  def move_to_survive
  end
end
