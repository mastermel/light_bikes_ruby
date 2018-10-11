class RaiderLogic < BotLogic
  def find_best_move
    # YOLO!
    move = available_moves.sample

    # If we haven't found someting yet I guess we're dead! Take the first move
    move || available_moves(true).first
  end
end
