class EnemySalvoProcessService
  def process(game, x, y)

    state = "miss"

    # Find any intersection ships
    game.ships.mine.at(x,y).each do |ship|
      state = "hit" if ship.intersects?(x, y)
      break if state == "hit"
    end

    Platform45Salvo.create({platform45_game_id: game.id, owner: "them", x: x, y: y, state: state })
    
    if state == "hit"
      game.open_hit_counter += 1
      game.save
    end

    {x: x, y: y, state: state}    
  end
end
